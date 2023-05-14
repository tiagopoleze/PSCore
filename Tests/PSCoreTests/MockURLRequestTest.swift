//
//  MockURLRequestTest.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import XCTest
@testable import PSCore

class MockURLRequestTest: XCTestCase {
    @available(iOS 15.0, *)
    func testMock() async {
        URLSessionConfiguration.swizzleMockURLProtocol = true
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let urlString = "https://tiagopoleze.io"
        let url = URL(string: urlString)!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.addResponse(
            for: RequestFilters.url(urlString),
            response: response,
            data: try? Bundle.module.decode(Person.self, from: "person.json").encode(),
            delay: 5
        )
        let request = URLRequest(url: url)
        let task = session.createTask(request, type: Person.self)
        let value = try? await task.value
        XCTAssertEqual(value?.firstName, "Tiago")
    }
}

private struct Person: Encodable, Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let isAmazing: Bool

}
