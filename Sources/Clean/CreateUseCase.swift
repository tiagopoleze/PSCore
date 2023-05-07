//
//  CreateUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// An open class to use to easily create anything
open class CreateUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseCreate: Create
>: UseCase where UseCaseCreate.InputCreate == Input,
                 UseCaseCreate.OutputCreate == Output {
    let useCase: UseCaseCreate
    let validations: [Validation]

    public init(useCase: UseCaseCreate, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }
        return try await useCase.create(input: input)
    }
}
