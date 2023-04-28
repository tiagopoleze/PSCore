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
    associatedtype Output
    func query(identifier: ObjectIdentifier) async throws -> Output
}

public protocol Read {
    associatedtype Input
    associatedtype Output
    func read(input: Input) async throws -> Output
}

public protocol Update {
    associatedtype Input
    @discardableResult func update(identifier: ObjectIdentifier, input: Input) async throws -> Bool
}

public protocol Delete {
    associatedtype Output
    @discardableResult func delete(identifier: ObjectIdentifier) async throws -> Output
}
