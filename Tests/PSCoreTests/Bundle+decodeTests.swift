import XCTest
@testable import PSCore

final class BundleDecodeTests: XCTestCase {
    @available(iOS 14.0, macOS 11.0, *)
    func testBundle() {
        XCTAssertThrowsError(try Bundle.module.decode(String.self, from: "here.json"))

        guard let person = try? Bundle.module.decode(Person.self, from: "person.json") else {
            XCTFail("Should always have this file.")
            return
        }

        XCTAssertTrue(person.isAmazing)
    }
    
    @available(iOS 14.0, macOS 11.0, *)
    func testDecode() {
        // Given
        let bundle = Bundle.module
        
        // When
        do {
            let person = try bundle.decode(Person.self, from: "person.json")
            
            // Then
            XCTAssertEqual(person.firstName, "Tiago")
            XCTAssertEqual(person.lastName, "Ferreira")
            XCTAssertEqual(person.age, 39)
            XCTAssertTrue(person.isAmazing)
        } catch {
            XCTFail("Failed to decode person.json: \(error)")
        }
    }
}

private struct Person: Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let isAmazing: Bool
}
