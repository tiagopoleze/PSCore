// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v13), .watchOS(.v7)],
    products: [
        .library(name: "PSCore", targets: ["PSCore", "Tagged", "Observer", "ChainOfResponsibility"])
    ],
    dependencies: [],
    targets: [
        .binaryTarget(name: "SwiftLintBinary", path: "./Libs/SwiftLintBinary.artifactbundle"),
        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .target(
            name: "PSCore",
            dependencies: [],
            plugins: ["SwiftLintPlugin"]
        ),
        .target(
            name: "Tagged",
            dependencies: [],
            plugins: ["SwiftLintPlugin"]
        ),
        .target(
            name: "ChainOfResponsibility",
            dependencies: [],
            plugins: ["SwiftLintPlugin"]
        ),
        .target(
            name: "Observer",
            dependencies: [],
            plugins: ["SwiftLintPlugin"]
        ),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore", "Tagged", "Observer", "ChainOfResponsibility"],
            resources: [.process("Resources/person.json")]
        )
    ]
)
