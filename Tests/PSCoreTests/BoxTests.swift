//
//  BoxTests.swift
//  
//
//  Created by Tiago Ferreira on 15/05/2023.
//

import XCTest
@testable import PSCore

final class BoxTests: XCTestCase {

    func test_create_a_box() {
        let uuid = UUID()
        let box = Box<String, UUID>(rawValue: uuid)
        let newBox = Box<String, UUID>(rawValue: uuid)
        let otherBox = Box<String, UUID>()
        XCTAssertTrue(box == newBox)
        XCTAssertFalse(box == otherBox)
    }
}
