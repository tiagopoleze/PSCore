//
//  CRUDs.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

public protocol Create {
    @discardableResult func create<Input>(input: Input) async throws -> Bool
}

public protocol Query {
    func query<Output>(identifier: ObjectIdentifier) async throws -> Output
}

public protocol Read {
    func read<Input, Output>(input: Input) async throws -> Output
}

public protocol Update {
    @discardableResult func update<Input>(identifier: ObjectIdentifier, input: Input) async throws -> Bool
}

public protocol Delete {
    @discardableResult func delete<Output>(identifier: ObjectIdentifier) async throws -> Output
}
