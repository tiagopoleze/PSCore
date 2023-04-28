//
//  CRUDs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol Create {
    associatedtype Input
    @discardableResult func create(input: Input) async throws -> Bool
}

public protocol Query {
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    associatedtype Output
    func query(identifier: ID) async throws -> Output
}

public protocol Read {
    associatedtype Input
    associatedtype Output
    func read(input: Input) async throws -> Output
}

public protocol Update {
    associatedtype Input
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    @discardableResult func update(identifier: ID, input: Input) async throws -> Bool
}

public protocol Delete {
    associatedtype Output
    // swiftlint:disable:next type_name
    associatedtype ID: Identificator
    @discardableResult func delete(identifier: ID) async throws -> Output
}
