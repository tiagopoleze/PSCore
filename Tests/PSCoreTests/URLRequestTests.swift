//
//  URLRequestTests.swift
//  
//
//  Created by Tiago Ferreira on 10/05/2023.
//

import XCTest
import PSCore

class URLRequestTests: XCTestCase {
    func testURLRequestInit() {
        let url = URL(string: "https://tiagopoleze.io")!
        let request = URLRequest(
            url: url,
            headers: [.init(key: "Content-Type", value: "application/json")],
            method: .get,
            authenticationType: .bearer("ijnkml")
        )
        XCTAssertEqual(request.url, url)
        XCTAssertTrue(request.httpMethod == "GET")
        XCTAssertTrue(request.allHTTPHeaderFields?.count == 2)
    }
}
