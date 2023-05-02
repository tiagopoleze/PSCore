//
//  Bundle+decodeTests.swift
//  
//
//  Created by Tiago Ferreira on 26/04/2023.
//

import XCTest
@testable import PSCore

final class BundleDecodeTests: XCTestCase {
    func testBundle() {
        Logging.level = .debug
        XCTAssertThrowsError(try Bundle.module.decode(String.self, from: "here.json"))

        guard let person = try? Bundle.module.decode(Person.self, from: "person.json") else {
            XCTFail("Should always have this file.")
            return
        }

        XCTAssertTrue(person.isAmazing)
    }
}

private struct Person: Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let isAmazing: Bool

}
