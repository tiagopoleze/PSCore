import Foundation

/// A class that represents the default settings for cloud operations.
public final class CloudDefaults {
    
    /// A singleton instance of `CloudDefaults` that can be accessed globally.
    public static var shared = CloudDefaults()
    private var notificationCenter: NotificationCenter?
    private var ignoreLocalChanges = false

    private init() { }

    deinit {
        notificationCenter?.removeObserver(self)
    }

    /// Starts the cloud defaults sync.
    public func start(_ notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        notificationCenter.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                       object: NSUbiquitousKeyValueStore.default,
                                       queue: .main,
                                       using: updateLocal)
        notificationCenter.addObserver(forName: UserDefaults.didChangeNotification,
                                       object: nil,
                                       queue: .main,
                                       using: updateRemote)
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
