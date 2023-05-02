//
//  CleanTests.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import XCTest
@testable import PSCore

class CleanTests: XCTestCase {
    func testAllCases() async {
        let createListDTOInput = CreateListDTOInput(title: "Tiago")
        let listMemoryRepository = ListMemoryRepository()
        let createListMemory = CreateListMemory(
            useCase: listMemoryRepository,
            validations: [IsEmptyValidation(input: createListDTOInput.title)]
        )
            do {
                let createListDTOOutput = try await createListMemory.execute(input: createListDTOInput)
                XCTAssertEqual(createListDTOOutput.list.title, createListDTOInput.title)
                let queryListDTOInput = QueryListDTOInput(id: createListDTOOutput.list.id)
                let queryListMemory = QueryListMemory(useCase: listMemoryRepository, validations: [])
                let queryListDTOOutput = try await queryListMemory.execute(input: queryListDTOInput)
                XCTAssertEqual(queryListDTOOutput.list?.id, createListDTOInput.id)
                guard let list = queryListDTOOutput.list else { return }
                list.title = "Tiago Ferreira"
                let updateListDTOInput = UpdateListMemoryDTOInput(id: list.id, newList: list)
                let updateUseCase = UpdateListMemory(
                    useCase: listMemoryRepository,
                    validations: [IsEmptyValidation(input: list.title)]
                )
                let updateUseCaseDTOOutput = try await updateUseCase.execute(input: updateListDTOInput)
                XCTAssertEqual(updateUseCaseDTOOutput.updatedList.title, list.title)
                XCTAssertTrue(listMemoryRepository.lists.count == 1)

                let deleteDTOInput = DeleteListMemoryDTOInput(id: updateUseCaseDTOOutput.updatedList.id)
                let deleteUseCase = DeleteListMemory(useCase: listMemoryRepository, validations: [])
                let deleteDTOOutput = try await deleteUseCase.execute(input: deleteDTOInput)
                XCTAssertEqual(deleteDTOOutput.deletedList?.title, list.title)
                XCTAssertFalse(listMemoryRepository.lists.count == 1)
                XCTAssertTrue(listMemoryRepository.lists.isEmpty)
            } catch {
                XCTFail(error.localizedDescription)
            }
    }
}

extension UUID: Identificator { }

struct IsEmptyValidation: Validation {
    var description: String { "IsEmptyValidation" }
    private let input: String

    init(input: String) {
        self.input = input
    }

    func validate() async throws -> Bool { !input.isEmpty }
}

class ListMemoryRepository {
    private(set) var lists = [List]()
}

extension ListMemoryRepository: Create {
    func create(input: CreateListDTOInput) async throws -> CreateListDTOOutput {
        let list = List(id: input.id, title: input.title)
        lists.append(list)
        return CreateListDTOOutput(input: input)
    }
}

extension ListMemoryRepository: Query {
    func query(input: QueryListDTOInput) async throws -> QueryListDTOOutput {
        if let list = lists.first(where: { $0.id == input.id }) {
            return QueryListDTOOutput(list: list)
        }

        throw NSError(domain: "Could not found List", code: 404)
    }
}

extension ListMemoryRepository: Update {
    func update(input: UpdateListMemoryDTOInput) async throws -> UpdateListMemoryDTOOutput {
        if let index = lists.firstIndex(where: { $0.id == input.id }) {
            lists[index] = input.newList
            return UpdateListMemoryDTOOutput(input: lists[index])
        }
        throw UseCaseError.isNil("No list item")
    }
}

extension ListMemoryRepository: Delete {
    func delete(input: DeleteListMemoryDTOInput) async throws -> DeleteListMemoryDTOOutput {
        if let index = lists.firstIndex(where: { $0.id == input.id }) {
            return DeleteListMemoryDTOOutput(list: lists.remove(at: Int(index)))
        }
        throw UseCaseError.isNil("No list item")
    }
}

struct CreateListDTOInput: DTOInput {
    var id = UUID()
    var description: String { "CreateListDTOInput" }

    let title: String

    init(title: String) {
        self.title = title
    }
}

struct CreateListDTOOutput: DTOOutput {
    let list: List

    init(input: CreateListDTOInput) {
        self.list = List(id: input.id, title: input.title)
    }
}

class CreateListMemory: CreateUseCase<CreateListDTOInput, CreateListDTOOutput, ListMemoryRepository> {}

struct QueryListDTOInput: DTOInput {
    var id: UUID
    var description: String { "QueryListDTOInput" }

    init(id: UUID) {
        self.id = id
    }
}

struct QueryListDTOOutput: DTOOutput {
    var list: List?
    init(input: QueryListDTOInput) {
        fatalError()
    }

    init(list: List) {
        self.list = list
    }
}

class QueryListMemory: QueryUseCase<QueryListDTOInput, QueryListDTOOutput, ListMemoryRepository> {}

struct UpdateListMemoryDTOInput: DTOInput {
    var id: UUID
    var description: String { "UpdateListMemoryDTOInput" }

    var newList: List

    init(id: UUID, newList: List) {
        self.id = id
        self.newList = newList
    }
}

struct UpdateListMemoryDTOOutput: DTOOutput {
    let updatedList: List

    init(input: List) {
        updatedList = input
    }
}

class UpdateListMemory: UpdateUseCase<UpdateListMemoryDTOInput, UpdateListMemoryDTOOutput, ListMemoryRepository> { }

struct DeleteListMemoryDTOInput: DTOInput {
    var description: String { "DeleteListMemoryDTOInput" }
    var id: UUID

    init(id: UUID) {
        self.id = id
    }
}

struct DeleteListMemoryDTOOutput: DTOOutput {
    var deletedList: List?

    init(input: DeleteListMemoryDTOInput) {
        fatalError()
    }

    init(list: List) {
        deletedList = list
    }
}

class DeleteListMemory: DeleteUseCase<DeleteListMemoryDTOInput, DeleteListMemoryDTOOutput, ListMemoryRepository> { }

class List: Hashable {
    let id: UUID
    var title: String
    var archived: Bool
    let todos: [String]

    init(
        id: UUID = .init(),
        title: String,
        archived: Bool = false,
        todos: [String] = []
    ) {
        self.id = id
        self.title = title
        self.archived = archived
        self.todos = todos
    }

    static func == (lhs: List, rhs: List) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.archived == rhs.archived && lhs.todos == rhs.todos
    }
}
