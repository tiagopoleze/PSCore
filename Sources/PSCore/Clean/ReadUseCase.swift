//
//  ReadUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

open class ReadUseCase<Input: DTOInput, Output: DTOOutput>: UseCase where Output.Input == Input {
    private let useCase: Read
    private let validations: [Validation]

    public init(useCase: Read, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: Input.self)) }
        for validation in validations {
            let result = try await validation.validate()
            if !result { throw UseCaseError.validation(String(describing: validation)) }
        }

        return try await useCase.read(input: input)
    }
}
