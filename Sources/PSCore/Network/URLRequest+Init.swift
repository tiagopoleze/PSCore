//
//  URLRequest+Init.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Foundation

public extension URLRequest {
    /// An easier inittialiser to URLRequest
    /// - Parameters:
    ///   - url: the url needed to create the request
    ///   - cachePolicy: the cache policy used. `default`: useProtocolCachePolicy
    ///   - timeoutInterval: the timeout of the request. `default`: 60.0
    ///   - headers: the headers of the request
    ///   - method: method used. `default`: get
    ///   - authenticationType: The authentication if needed
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
        if let header = authenticationType?.header { addValue(header.value, forHTTPHeaderField: header.key)}
    }
}
