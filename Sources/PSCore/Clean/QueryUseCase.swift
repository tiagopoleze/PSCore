//
//  QueryUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

open class QueryUseCase<Input: DTOInput, Output: DTOOutput>: UseCase {
    private let useCase: Query
    private let validations: [Validation]

    public init(useCase: Query, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: input)) }
        for validation in validations {
            let result = try await validation.validate()
            if !result { throw UseCaseError.validation(String(describing: validation)) }
        }

        return try await useCase.query(identifier: input.id)
    }
}
