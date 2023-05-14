import Foundation

public extension URLRequest {
    init(
        url: URL,
        cachePolicy: CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0,
        headers: [HTTPHeader] = [],
        method: HTTPMethod = .get,
        authenticationType: AuthenticationType? = nil
    ) {
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        httpMethod = method.httpMethod
        if let body = method.body { httpBody = body }
        headers.forEach { addValue($0.value, forHTTPHeaderField: $0.key) }
        if let header = authenticationType?.header { addValue(header.value, forHTTPHeaderField: header.key) }
    }
}
