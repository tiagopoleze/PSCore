//
//  CreateUseCase.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

open class CreateUseCase<Input: DTOInput, Output: DTOOutput>: UseCase where Output.Input == Input {
    private let useCase: Create
    private let validations: [Validation]

    public init(useCase: Create, validations: [Validation]) {
        self.useCase = useCase
        self.validations = validations
    }

    open func execute(input: Input?) async throws -> Output {
        guard let input else { throw UseCaseError.isNil(String(describing: "\(self).\(Input.self)")) }
        for validation in validations {
            let isValid = try await validation.validate()
            if !isValid { throw UseCaseError.validation(String(describing: "\(self).\(validations)")) }
        }
        let result = try await useCase.create(input: input)
        if !result { throw UseCaseError.repository("\(self).useCase.create(input:)")}
        return Output(input: input)
    }
}
