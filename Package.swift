// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    products: [
        .library(name: "PSCore", targets: ["PSCore", "Observer", "ChainOfResponsibility"])
    ],
    targets: [
        .target(name: "PSCore"),
        .target(name: "ChainOfResponsibility"),
        .target(name: "Observer"),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore"],
            resources: [.process("Resources/person.json")]
        ),
        .testTarget(name: "ObserverTests", dependencies: ["Observer"]),
        .testTarget(name: "ChainOfResponsibilityTests", dependencies: ["ChainOfResponsibility"])
    ]
)
