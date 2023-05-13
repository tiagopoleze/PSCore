//
//  CloudDefaults.swift
//  
//
//  Created by Tiago Ferreira on 13/05/2023.
//

import Foundation

public final class CloudDefaults {
    public static var shared = CloudDefaults()
    private var ignoreLocalChanges = false

    private init() { }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func start() {
        NotificationCenter
            .default
            .addObserver(
                forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: NSUbiquitousKeyValueStore.default,
                queue: .main,
                using: updateLocal
            )

        NotificationCenter
            .default
            .addObserver(
                forName: UserDefaults.didChangeNotification,
                object: nil,
                queue: .main,
                using: updateRemote
            )
    }

    private func updateRemote(note: Notification) {
        guard ignoreLocalChanges == false else { return }

        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            guard key.hasPrefix("sync-") else { continue }
            NSUbiquitousKeyValueStore.default.set(value, forKey: key)
        }
    }

    private func updateLocal(note: Notification) {
        ignoreLocalChanges = true

        for (key, value) in NSUbiquitousKeyValueStore.default.dictionaryRepresentation {
            guard key.hasPrefix("sync-") else { continue }
            UserDefaults.standard.set(value, forKey: key)
        }

        ignoreLocalChanges = false
    }
}
