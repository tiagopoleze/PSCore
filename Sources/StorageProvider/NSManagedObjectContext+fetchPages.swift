//
//  NSManagedObjectContext+fetchPages.swift
//  
//
//  Created by Tiago Ferreira on 13/05/2023.
//

import CoreData

extension NSManagedObjectContext {
    func fetchPage<T: NSManagedObject>(
        _ pageIndex: Int,
        pageSize: Int,
        for request: NSFetchRequest<T>
    ) throws -> [T] {
        request.fetchLimit = pageSize
        request.fetchOffset = pageSize * pageIndex
        return try fetch(request)
    }
}
