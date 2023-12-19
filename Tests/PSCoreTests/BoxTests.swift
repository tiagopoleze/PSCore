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
    
    func test_box_id_when_rawValue_is_identifiable() {
        let identifiableValue = IdentifiableValue(id: 123)
        let box = Box<IdentifiableValue, Int>(rawValue: identifiableValue.id)
        
        XCTAssertEqual(box.rawValue, identifiableValue.id)
    }
    
    func test_box_init_with_random_uuid() {
        let box = Box<String, UUID>()
        
        XCTAssertNotNil(box.rawValue)
    }
    
    func test_box_init_with_valid_uuid_string() {
        let uuidString = UUID().uuidString
        let box = Box<String, UUID>(uuidString: uuidString)
        
        XCTAssertNotNil(box)
        XCTAssertEqual(box?.rawValue.uuidString, uuidString)
    }
    
    func test_box_init_with_invalid_uuid_string() {
        let box = Box<String, UUID>(uuidString: "invalid uuid string")
        
        XCTAssertNil(box)
    }
    
    func test_box_map_transforms_rawValue() {
        let box = Box<String, Int>(rawValue: 5)
        let transformedBox = box.map { $0 * 2 }
        
        XCTAssertEqual(transformedBox.rawValue, 10)
    }
    
    func test_box_conforms_to_identifiable() {
        
        let identifiableValue = IdentifiableValue(id: 123)
        let box = Box<IdentifiableValue, IdentifiableValue>(rawValue: identifiableValue)
        
        XCTAssertEqual(box.id, identifiableValue.id)
    }
}

struct IdentifiableValue: Identifiable {
    let id: Int
}
