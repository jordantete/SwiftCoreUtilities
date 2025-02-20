# SwiftCoreUtilities

[![License: MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/jordantete/SwiftCoreUtilities/actions/workflows/unit_tests_workflow.yml/badge.svg)](https://github.com/jordantete/SwiftCoreUtilities/actions)

A collection of reusable Swift components for your iOS projects.

## 📖 Table of Contents

- [📦 Features](#-features)
- [📲 Installation](#-installation)
- [🛠 Usage](#-usage)
  - [🔄 Observer Pattern Implementation](#-observer-pattern-implementation)
  - [💾 Data Persistence (CoreData, SwiftData, and Secure Storage)](#-data-persistence-coredata-swiftdata-and-secure-storage)
    - [1️⃣ CoreData – Local Database Storage](#1️⃣-coredata--local-database-storage)
    - [2️⃣ SwiftData – Next-Gen Persistence (iOS 17+)](#2️⃣-swiftdata--next-gen-persistence-ios-17)
    - [3️⃣ KeychainManager – Secure Storage for Sensitive Data](#3️⃣-keychainmanager--secure-storage-for-sensitive-data)
  - [🌐 Networking (API Requests)](#-networking-api-requests)
  - [📍 User Location Tracking](#-user-location-tracking)
  - [📷 Permissions Management](#-permissions-management)
  - [📡 Background Task Management](#-background-task-management)
  - [🎨 UI Utilities (SwiftUI Helpers & ViewModifiers)](#-ui-utilities-swiftui-helpers--viewmodifiers)
- [🔥 Why Choose SwiftCoreUtilities?](#-why-choose-swiftcoreutilities)
- [🤝 Contributing](#-contributing)
- [⚖️ License](#-license)


## 📦 Features

- 🏗 **Modular Architecture** – Service Locator for easy dependency injection
- 🔄 **Observer Pattern Implementation** – Custom event-driven notification system for seamless communication between components  
- 💾 **Data Persistence** – Easy to use abstraction for **CoreData**, **SwiftData**, **Keychain** and **UserDefaults**
- 🌐 **Networking** – Simple API client with request builder and error handling  
- 📍 **User Location Tracking** – Efficient **CoreLocation** integration with heading & accelerometer support  
- 🎛 **Permissions Management** – Centralized access for **Location**, **Notifications**, **Camera**, **Photos**, and **Bluetooth**  
- 📡 **Background Task Management** – Periodic background execution with iOS **BGTaskScheduler**  
- 🎨 **UI Utilities** – SwiftUI modifiers, helpers for **navigation**, **keyboard**, **animations**, etc..


## 📲 Installation

You can install **SwiftCoreUtilities** via **SPM**:

1. Open **Xcode**, go to **Project Navigator** and select your project.
2. Click on **Package Dependencies** in the project settings.
3. Click the **+** button at the bottom left to add a new package.
4. Enter the repo URL: `https://github.com/jordantete/SwiftCoreUtilities.git`
5. Choose the **Latest Version** or a specific version you need, then click **Add Package**.
6. Select **SwiftCoreUtilities** as a dependency for your target and click **Add Package**.

Now you can import and start using the utilities in your project:
```swift
import SwiftCoreUtilities
```


## 🛠 Usage

### 🔄 **Observer Pattern Implementation**

```swift
import SwiftCoreUtilities

class MyObserver: Observer {
    func update(event: NotificationEvent) {
        switch event {
        case .permissionsChanged(let permissionType, let state):
            print("Permission changed: \(permissionType) - New state: \(state)")
        case .syncStateChanged(let state):
            print("Sync state changed: \(state)")
        }
    }
}

let observer = MyObserver()
NotificationManager.shared.addObserver(observer)
```

To emit an event from anywhere in your app:
```swift
NotificationManager.shared.post(event: .aNotificationEvent(myEventValue: "aString"))
```


### 💾 **Data Persistence (CoreData, SwiftData, and Secure Storage)**

SwiftCoreUtilities offers multiple storage solutions, allowing developers to choose the best persistence layer for their needs.

#### 1️⃣ CoreData – Local Database Storage

CoreData is a powerful framework for managing structured data. The CoreDataManager simplifies entity creation, fetching, and deletion.

```swift
import SwiftCoreUtilities

let coreDataManager = CoreDataManagerImpl()

// Saving a new entity
try? coreDataManager.save(StoredEntity.self) { entity in
    entity.name = "Example Data"
    entity.timestamp = Date()
}

// Fetching entities
let storedEntities: [StoredEntity] = try coreDataManager.fetchData(entity: StoredEntity.self)

// Deleting an entity
if let entity = storedEntities.first {
    coreDataManager.delete(entity)
}

// Deleting all entities
coreDataManager.deleteAll(entity: StoredEntity.self)
```

#### 2️⃣ SwiftData – Next-Gen Persistence (iOS 17+)

For apps targeting iOS 17+, SwiftData provides a simpler and more Swift-native approach to persistence.

```swift
import SwiftCoreUtilities
import SwiftData

@Model
class UserProfile {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

// Creating a model and storing data
let userProfile = UserProfile(name: "Alice", age: 28)
SwiftDataManager.shared.save(userProfile)

// Fetching all stored profiles
let profiles: [UserProfile] = SwiftDataManager.shared.fetch(UserProfile.self)

// Deleting a specific object
if let profile = profiles.first {
    SwiftDataManager.shared.delete(profile)
}

// Deleting all profiles
SwiftDataManager.shared.deleteAll(UserProfile.self)
```

👉 SwiftData is recommended for simpler models and modern apps targeting iOS 17+.
👉 CoreData remains the best choice for complex data relationships and compatibility with iOS 16+.


#### 3️⃣ KeychainManager – Secure Storage for Sensitive Data

For securely storing API keys, authentication tokens, and user credentials, KeychainManager provides an easy-to-use interface.

```swift
import SwiftCoreUtilities

let keychain = KeychainManager()

// Storing sensitive data
try? keychain.save("my_secure_token", forKey: "AuthToken")

// Retrieving stored data
if let token: String = try? keychain.get(forKey: "AuthToken") {
    print("Retrieved token:", token)
}

// Deleting sensitive data
try? keychain.delete(forKey: "AuthToken")
```

👉 Use Keychain for credentials, API keys, and any sensitive user data.
👉 It ensures data remains secure, even after the app is deleted and reinstalled.


### 🌐 **Networking (API Requests)**

```swift
import SwiftCoreUtilities

let networkService = NetworkServiceImpl()

let request = APIRequest(url: "https://api.example.com/data", method: .get)

Task {
    do {
        let response: MyDecodableModel = try await networkService.request(request, expecting: MyDecodableModel.self)
        print("Success:", response)
    } catch {
        print("Request failed:", error)
    }
}
```


### 📍 **User Location Tracking**

```swift
import SwiftCoreUtilities

class MyLocationDelegate: UserLocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        print("New location:", location)
    }
    
    func didFailWithError(_ error: Error) {
        print("Location error:", error)
    }
}

let locationManager = UserLocationManagerImpl()
locationManager.delegate = MyLocationDelegate()
locationManager.startTracking()
```


### 📷 **Permissions Management**

```swift
import SwiftCoreUtilities

let permissionService = PermissionServiceImpl(
    locationPermissionManager: LocationPermissionManagerImpl(),
    notificationPermissionManager: NotificationPermissionManagerImpl()
)

permissionService.requestPermission(for: .location) { state in
    print("Location permission state:", state)
}

let notificationStatus = permissionService.permissionState(for: .notification)
print("Current notification permission:", notificationStatus)
```


### 📡 **Background Task Management**

```swift
import SwiftCoreUtilities

let backgroundSyncService = BackgroundSyncServiceImpl()

backgroundSyncService.startSyncing { 
    print("Executing periodic background task")
}
```


### 🎨 **UI Utilities (SwiftUI Helpers & ViewModifiers)**

For a full demonstration of available UI utilities, see the Test App included in the repository. 


## 🔥 Why Choose SwiftCoreUtilities?

- **Modular & Lightweight** – Pick and use only the components you need.
- **Swift Concurrency** – Leverages modern async/await patterns.
- **Cross-Project Compatibility** – Works with any iOS app, including UIKit & SwiftUI.
- **Well-Tested & Maintainable** – Unit tests included to ensure stability.


## 🤝 Contributing

We welcome contributions! Feel free to fork, submit a pull request, or open an issue if you have suggestions.


## ⚖️ License

This project is licensed under the MIT License – see the LICENSE file for details.
