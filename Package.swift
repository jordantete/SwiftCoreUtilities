// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftCoreUtilities",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftCoreUtilities",
            targets: ["SwiftCoreUtilities"])
    ],
    targets: [
        .target(
            name: "SwiftCoreUtilities",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftCoreUtilitiesTests",
            dependencies: ["SwiftCoreUtilities"],
            path: "Tests"
        )
    ]
)
