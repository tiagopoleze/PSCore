//
//  ChainOfResponsibilityTests.swift
//  
//
//  Created by Tiago Ferreira on 02/05/2023.
//

import XCTest
@testable import PSCore

class ChainOfResponsibilityTests: XCTestCase {
    func testChainOfResponsibility() throws {
        let first = ChainOfResponsibility<Int, Int> { number in
            number == 10
        } result: { number in
            number + 1
        }

        let second = ChainOfResponsibility<Int, Int>(next: first) { number in
            number == 5
        } result: { number in
            number + 2
        }

        let result = try second.execute(input: 10)
        let result2 = try second.execute(input: 5)
        XCTAssertEqual(result, 11)
        XCTAssertEqual(result2, 7)

        XCTAssertThrowsError(try first.execute(input: 7)) { error in
            XCTAssertEqual(error as? ChainOfResponsibilityError, ChainOfResponsibilityError.noNextCase)
        }

        let third = ChainOfResponsibility<Int, Bool>(next: second) {
            $0 == 7
        } result: {
            $0 == 7
        }
        XCTAssertThrowsError(try third.execute(input: 5)) { error in
            XCTAssertEqual(error as? ChainOfResponsibilityError, ChainOfResponsibilityError.noEqualChainOfResponsibility)
        }
    }
}
