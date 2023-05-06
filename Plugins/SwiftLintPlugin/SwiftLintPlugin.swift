//
//  SwiftLintPlugin.swift
//  
//
//  Created by Tiago Ferreira on 06/05/2023.
//

import PackagePlugin

@main
struct SwiftLintPlugins: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            .buildCommand(
                displayName: "Linting \(target.name)...",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--no-cache",
                    "--config",
                    "\(context.package.directory.string)/Plugins/SwiftLintPlugin/swiftlint.yml",
                    target.directory.string   // only lint the files in the target directory
                ],
                environment: [:]
            )
        ]
    }
}
