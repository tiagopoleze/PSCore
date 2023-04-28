//
//  MockURLRequestTest.swift
//  
//
//  Created by Tiago Ferreira on 28/04/2023.
//

import XCTest
@testable import PSCore

class MockURLRequestTest: XCTestCase {
    func testMock() async throws {
        URLSessionConfiguration.swizzleMockURLProtocol = true
        let urlString = "https://tiagopoleze.io"
        let url = URL(string: urlString)!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.addResponse(for: RequestFilters.url(urlString), response: response, delay: 10)
        let request = URLRequest(url: url)
        let (_, urlResponse) = try await URLSession.shared.data(for: request)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else { return }
        XCTAssertEqual(httpURLResponse.statusCode, 200)
    }
}

private struct Person: Encodable, Decodable {
    let firstName: String
    let lastName: String
    let age: Int
    let isAmazing: Bool

}
