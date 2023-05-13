//
//  PersistenceManager.swift
//  
//
//  Created by Tiago Ferreira on 13/05/2023.
//

import CoreData
import SwiftUI

public enum PersistenceManagerEnvironment {
    case inMemory((NSManagedObjectContext) -> Void)
    case `default`
}

public class PersistenceManager {
    public let persistentContainer: NSPersistentContainer

    public init(
        environment: PersistenceManagerEnvironment = .default,
        name: String = "Main"
    ) {
        persistentContainer = NSPersistentCloudKitContainer(name: name)

        if case .inMemory = environment {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("loading data: \(error.localizedDescription)")
            }
        }

        if case let .inMemory(createSampleData) = environment {
            preview(createSampleData: createSampleData)
        }

        let notificationCenter = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification

        notificationCenter.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self else { return }
            self.save()
        }
    }

    private func preview(createSampleData: (NSManagedObjectContext) -> Void) {
        createSampleData(persistentContainer.viewContext)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("creating preview \(error.localizedDescription)")
        }
    }

    public func save() {
        if persistentContainer.viewContext.hasChanges {
            try? persistentContainer.viewContext.save()
        }
    }

    public func delete(_ object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
    }
}
