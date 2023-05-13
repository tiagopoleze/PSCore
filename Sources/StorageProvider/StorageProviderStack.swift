//
//  StorageProviderStack.swift
//  
//
//  Created by Tiago Ferreira on 13/05/2023.
//

import CoreData

public struct ManagedObjectModelData {
    let bundle: Bundle
    let name: String

    public init(bundle: Bundle, name: String) {
        self.bundle = bundle
        self.name = name
    }
}

public enum StorageProviderStackError: Error {
    case failedLocateMOMDFileFor(String)
    case failedLoadMOMDFileFor(String)
    case failToSetUpTheCoordinator(String)
    case couldNotFoundDocumentDirectory
}

final public class StorageProviderStack {
    private let momData: ManagedObjectModelData
    private let fileManager: FileManager

    public init(
        momData: ManagedObjectModelData,
        fileManager: FileManager
    ) {
        self.momData = momData
        self.fileManager = fileManager
    }

    func managedObjectModel() throws -> NSManagedObjectModel {
        let withExtension = "momd"
        guard let url = momData.bundle.url(forResource: momData.name, withExtension: withExtension) else {
            throw StorageProviderStackError
                .failedLocateMOMDFileFor("\(momData.name).\(withExtension) in \(momData.bundle.bundlePath)")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw StorageProviderStackError
                .failedLoadMOMDFileFor("\(momData.name).\(withExtension) in \(momData.bundle.bundlePath)")
        }

        return model
    }

    func coordinator() throws -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: try managedObjectModel())
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw StorageProviderStackError.couldNotFoundDocumentDirectory
        }
        let sqlPath = documentsDirectory.appending(component: "MyModel.sqlite")
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: sqlPath,
                options: nil
            )
        } catch {
            throw StorageProviderStackError.failToSetUpTheCoordinator(error.localizedDescription)
        }
        return coordinator
    }

    public func viewContext(
        concurrencyType: NSManagedObjectContextConcurrencyType = .mainQueueConcurrencyType
    ) throws -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        context.persistentStoreCoordinator = try coordinator()
        return context
    }
}
