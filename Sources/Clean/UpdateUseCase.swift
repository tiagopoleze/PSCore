//
//  UpdateUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// An open class to use to easily update anything
open class UpdateUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseUpdate: Update
>: UseCase where Output == UseCaseUpdate.OutputUpdate,
                 UseCaseUpdate.InputUpdate == Input,
                 UseCaseUpdate.InputUpdate.ID == Input.ID,
                 UseCaseUpdate.InputUpdate == Input {
    private let useCase: UseCaseUpdate
    private let validations: [Validation]

    public init(useCase: UseCaseUpdate, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }
        return try await useCase.update(input: input)
    }
}
