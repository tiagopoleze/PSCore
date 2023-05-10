// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSCore",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v13), .watchOS(.v7)],
    products: [
        .library(name: "PSCore", targets: ["PSCore", "Tagged", "Observer", "ChainOfResponsibility", "Clean"])
    ],
    dependencies: [
        .package(url: "https://tiagopoleze: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@github.com/tiagopoleze/SwiftlintPlugin", branch: "main")
    ],
    targets: [
        .target(name: "PSCore", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLintPlugin")]),
        .target(name: "Tagged", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLintPlugin")]),
        .target(name: "ChainOfResponsibility", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLintPlugin")]),
        .target(name: "Observer", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLintPlugin")]),
        .target(name: "Clean", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLintPlugin")]),
        .testTarget(
            name: "PSCoreTests",
            dependencies: ["PSCore"],
            resources: [.process("Resources/person.json")]
        ),
        .testTarget(name: "ObserverTests", dependencies: ["Observer"]),
        .testTarget(name: "ChainOfResponsibilityTests", dependencies: ["ChainOfResponsibility"]),
        .testTarget(name: "CleanTests", dependencies: ["Clean"]),
        .testTarget(name: "TaggedTests", dependencies: ["Tagged"])
    ]
)
