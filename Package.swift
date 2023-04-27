// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    platforms: [.iOS(.v13), .macOS(.v12), .tvOS(.v13), .watchOS(.v7)],
    products: [
        .library(
            name: "PSCore",
            targets: ["PSCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", branch: "main")
    ],
    targets: [
        .target(
            name: "PSCore",
            dependencies: [],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore"],
            resources: [
                .process("Resources/person.json")
            ]
        ),
    ]
)
