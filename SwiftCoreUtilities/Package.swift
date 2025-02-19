// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftCoreUtilities",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "SwiftCoreUtilities",
            targets: ["SwiftCoreUtilities"])
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.0")
    ],
    targets: [
        .target(
            name: "SwiftCoreUtilities",
            dependencies: [],
            path: "Sources",
            exclude: [],
            swiftSettings: [
                .define("SWIFTDATA_AVAILABLE", .when(platforms: [.iOS], configuration: .release))
            ],
            plugins: [
                 .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
             ]
        ),
        .testTarget(
            name: "SwiftCoreUtilitiesTests",
            dependencies: ["SwiftCoreUtilities"],
            path: "Tests"
        )
    ]
)
