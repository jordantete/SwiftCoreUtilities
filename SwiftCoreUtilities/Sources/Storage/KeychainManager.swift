import Security
import Foundation

public enum KeychainError: Error {
    case unableToSave(OSStatus)
    case unableToRetrieve(OSStatus)
    case unableToDelete(OSStatus)

    var localizedDescription: String {
        switch self {
        case .unableToSave(let status):
            return "Keychain: Unable to save data. Status code: \(status)"
        case .unableToRetrieve(let status):
            return "Keychain: Unable to retrieve data. Status code: \(status)"
        case .unableToDelete(let status):
            return "Keychain: Unable to delete data. Status code: \(status)"
        }
    }
}

public enum KeychainManagerKeys {
    static let aKey = "aKey"
}

public protocol KeychainManager {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func get<T: Codable>(forKey key: String) throws -> T?
    func delete(forKey key: String) throws
}

public final class KeychainManagerImpl: KeychainManager {
    // MARK: - Initialization

    init() {}
    
    // MARK: - Public methods
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Delete any existing value
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.unableToSave(status)
        }
    }

    public func get<T: Codable>(forKey key: String) throws -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else { return nil }

        return try JSONDecoder().decode(T.self, from: data)
    }

    public func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unableToDelete(status)
        }
    }
}
