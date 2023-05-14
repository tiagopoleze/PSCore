// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(name: "PSCore", targets: ["PSCore", "Observer", "ChainOfResponsibility"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", branch: "main")
    ],
    targets: [
        .target(name: "PSCore", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(name: "ChainOfResponsibility", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(name: "Observer", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore"],
            resources: [.process("Resources/person.json")]
        ),
        .testTarget(name: "ObserverTests", dependencies: ["Observer"]),
        .testTarget(name: "ChainOfResponsibilityTests", dependencies: ["ChainOfResponsibility"])
    ]
)
