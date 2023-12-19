//
//  MockDecoderTests.swift
//  
//
//  Created by Tiago Ferreira on 19/12/2023.
//

import XCTest
@testable import PSCore

final class MockDecoderTests: XCTestCase {
    var mockDecoder: MockDecoder!

    override func setUp() {
        super.setUp()
        mockDecoder = MockDecoder()
    }

    override func tearDown() {
        mockDecoder = nil
        super.tearDown()
    }

    func testDecode_withValidData() {
        // Given
        let dataProvider: [String: Any] = ["firstName": "Tiago", "lastName": "Ferreira", "age": 39, "isAmazing": true]

        // When
        do {
            let person = try mockDecoder.decode(Person.self, from: dataProvider)

            // Then
            XCTAssertEqual(person.firstName, "Tiago")
            XCTAssertEqual(person.lastName, "Ferreira")
            XCTAssertEqual(person.age, 39)
            XCTAssertTrue(person.isAmazing)
        } catch {
            XCTFail("Failed to decode person: \(error)")
        }
    }

    func testDecode_withInvalidData() {
        // Given
        let dataProvider: [String: Any] = ["firstName": "Tiago", "lastName": "Ferreira", "age": "39", "isAmazing": true]

        // When
        XCTAssertThrowsError(try mockDecoder.decode(Person.self, from: dataProvider)) { error in
            // Then
            guard case DecodingError.typeMismatch = error else {
                XCTFail("Expected DecodingError.typeMismatch, but got \(error)")
                return
            }
        }
    }

    func testDecode_withMissingData() {
        // Given
        let dataProvider: [String: Any] = ["firstName": "Tiago", "lastName": "Ferreira", "isAmazing": true]

        // When
        XCTAssertThrowsError(try mockDecoder.decode(Person.self, from: dataProvider)) { error in
            // Then
            guard case DecodingError.typeMismatch = error else {
                XCTFail("Expected DecodingError.typeMismatch, but got \(error)")
                return
            }
        }
    }
}
