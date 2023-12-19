// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
    products: [
        .library(name: "PSCore", targets: ["PSCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "PSCore"),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore"],
            resources: [.process("Resources/person.json")]
        )
    ]
)
