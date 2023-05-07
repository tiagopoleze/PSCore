//
//  CRUDs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// Protocol to `create` instances
public protocol Create {
    associatedtype InputCreate
    associatedtype OutputCreate
    /// The call to create
    /// - Parameter input: Your generic input parameter
    /// - Returns: your generic object
    @discardableResult func create(input: InputCreate) async throws -> OutputCreate
}

/// Protocol to `Query` instances
public protocol Query {
    associatedtype InputQuery: DTOInput
    associatedtype OutputQuery
    /// The call to query
    /// - Parameter input: The input with an identifier to query
    /// - Returns: The object returned
    func query(input: InputQuery) async throws -> OutputQuery
}

/// Protocol to `Read` instances
public protocol Read {
    associatedtype InputRead: DTOInput
    associatedtype OutputRead
    /// The call to read
    /// - Parameter input: Any valid input
    /// - Returns: The object returned
    func read(input: InputRead) async throws -> OutputRead
}

/// Protocol to `Update` instances
public protocol Update {
    associatedtype InputUpdate: DTOInput
    associatedtype OutputUpdate
    /// The call to update
    /// - Parameters:
    ///   - input: The new data
    /// - Returns: the new object
    @discardableResult func update(input: InputUpdate) async throws -> OutputUpdate
}

/// Protocol to `Delete` instances
public protocol Delete {
    associatedtype InputDelete: DTOInput
    associatedtype OutputDelete
    /// The call to delete
    /// - Parameter input: The input that have an identifier
    /// - Returns: The object deleted
    @discardableResult func delete(input: InputDelete) async throws -> OutputDelete
}
