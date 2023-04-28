//
//  CRUDs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol Create {
    associatedtype InputCreate
    @discardableResult func create(input: InputCreate) async throws -> Bool
}

public protocol Query {
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    associatedtype OutputQuery
    func query(identifier: ID) async throws -> OutputQuery
}

public protocol Read {
    associatedtype InputRead
    associatedtype OutputRead
    func read(input: InputRead) async throws -> OutputRead
}

public protocol Update {
    associatedtype InputUpdate
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    @discardableResult func update(identifier: ID, input: InputUpdate) async throws -> Bool
}

public protocol Delete {
    associatedtype OutputDelete
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    @discardableResult func delete(identifier: ID) async throws -> OutputDelete
}
