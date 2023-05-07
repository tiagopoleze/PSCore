//
//  QueryUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// An open class to use to easily query anything
open class QueryUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseQuery: Query
>: UseCase where UseCaseQuery.OutputQuery == Output,
                 UseCaseQuery.InputQuery.ID == Input.ID,
                 UseCaseQuery.InputQuery == Input {
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
        return try await useCase.query(input: input)
    }
}
