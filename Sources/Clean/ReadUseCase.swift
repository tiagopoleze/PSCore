//
//  ReadUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

/// An open class to use to easily read anything
open class ReadUseCase<
    Input: DTOInput,
    Output: DTOOutput,
    UseCaseRead: Read
>: UseCase where Output.Input == Input,
                 UseCaseRead.InputRead == Input,
                 UseCaseRead.OutputRead == Output {
    private let useCase: UseCaseRead
    private let validations: [Validation]

    public init(useCase: UseCaseRead, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }

        return try await useCase.read(input: input)
    }
}
