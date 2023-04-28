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
        guard let input else { throw UseCaseError.isNil(String(describing: Input.self)) }
        for validation in validations {
            let result = try await validation.validate()
            if !result { throw UseCaseError.validation(String(describing: validation)) }
        }
        let result = try await useCase.create(input: input)
        if !result { throw UseCaseError.repository(action: "createRepository.create(input:)")}
        return Output(input: input)
    }
}
