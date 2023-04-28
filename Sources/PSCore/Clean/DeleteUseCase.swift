//
//  DeleteUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

open class DeleteUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseDelete: Delete
>: UseCase where UseCaseDelete.Output == Output, UseCaseDelete.ID == Input.ID {
    private let useCase: UseCaseDelete
    private let validations: [Validation]

    public init(useCase: UseCaseDelete, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }

        return try await useCase.delete(identifier: input.id)
    }
}
