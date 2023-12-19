import XCTest
@testable import PSCore

final class BundleDecodeTests: XCTestCase {
    func testBundle() {
        XCTAssertThrowsError(try Bundle.module.decode(String.self, from: "here.json"))
        
        guard let person = try? Bundle.module.decode(Person.self, from: "person.json") else {
            XCTFail("Should always have this file.")
            return
        }
        
        XCTAssertTrue(person.isAmazing)
    }
    
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
    
    func testNoContentToURL() {
        // Given
        let bundle = Bundle.module
        let url = URL(string: "https://example.com")!
        
        XCTAssertThrowsError(try bundle.decode(Person.self, from: url.absoluteString),
                             "Should throw BundleDecodeError.noContentTo") { error in
            guard case BundleDecodeError.noValidURL(let url) = error else {
                XCTFail("Expected BundleDecodeError.noValidURL, but got \(error)")
                return
            }
            
            XCTAssertEqual(url, url)
        }
    }
}

struct Person: Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let isAmazing: Bool
}
