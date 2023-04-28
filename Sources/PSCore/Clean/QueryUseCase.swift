//
//  QueryUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

open class QueryUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseQuery: Query
>: UseCase where UseCaseQuery.Output == Output, UseCaseQuery.ID == Input.ID {
    private let useCase: UseCaseQuery
    private let validations: [Validation]

    public init(useCase: UseCaseQuery, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }

        return try await useCase.query(identifier: input.id)
    }
}
