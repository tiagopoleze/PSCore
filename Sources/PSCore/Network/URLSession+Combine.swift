//
//  URLSession+Combine.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Combine
import Foundation

extension URLSession {
    /// An easier way to create a Publisher
    /// - Parameters:
    ///   - request: the request of the publisher
    ///   - type: the type returned
    ///   - decoder: the decoder used to decode the data
    ///   - scheduler: the scheduler used to call the method
    /// - Returns: The returned type
    public func createPublisher<T: Decodable, S: Scheduler>(
        _ request: URLRequest,
        type: T.Type,
        decoder: JSONDecoder = .init(),
        scheduler: S = DispatchQueue.main
    ) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: request)
            .retry(1)
            .tryMap {
                guard let httpResponse = $0.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return $0.data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: scheduler)
            .eraseToAnyPublisher()
    }
}
