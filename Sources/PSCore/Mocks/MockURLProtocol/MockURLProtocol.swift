import Foundation

private struct MockURLResponse {

    init(filter: @escaping RequestFilter, response: HTTPURLResponse?, data: Data?, error: Error?, delay: TimeInterval) {
        if error != nil && data != nil {
            assertionFailure("You can not set an error alongside Data")
        }

        self.filter = filter
        self.response = response
        self.data = data
        self.error = error
        self.delay = delay
    }

    let filter: RequestFilter
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    let delay: TimeInterval
}

public final class MockURLProtocol: URLProtocol {

    private static var mockQueryResponses = [MockURLResponse]()

    private var body: Data? {
        guard let bodyStream = request.httpBodyStream else { return nil }

        bodyStream.open()

        let bufferSize: Int = 16

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        var data = Data()

        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }

        buffer.deallocate()

        bodyStream.close()
        return data
    }

    public static func addResponse(
        for filter: @escaping RequestFilter,
        response: HTTPURLResponse? = nil,
        data: Data? = nil,
        error: Error? = nil,
        delay: TimeInterval = .zero
    ) {
        mockQueryResponses.append(
            MockURLResponse(
                filter: filter,
                response: response,
                data: data,
                error: error,
                delay: delay
            )
        )
    }

    public static func reset() {
        mockQueryResponses = []
    }

    private class func response(for request: URLRequest) -> MockURLResponse? {
        return MockURLProtocol
            .mockQueryResponses
            .reversed()
            .first {
                $0.filter(request)
            }
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        response(for: request) != nil
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        guard let response = MockURLProtocol.response(for: request) else {
            assertionFailure("No response found for query")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + response.delay) {
            if let response = response.response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = response.data {
                self.client?.urlProtocol(self, didLoad: data)
            }

            if let error = response.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }

            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    public override func stopLoading() {}
}
