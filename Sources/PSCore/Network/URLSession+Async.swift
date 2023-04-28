//
//  URLSession+Async.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Foundation

public protocol ConcurrencyFetch {
    func fetch<T: Decodable>(
        _ request: URLRequest,
        type: T.Type,
        decoder: JSONDecoder,
        delegate: URLSessionTaskDelegate?
    ) -> Task<T, Error>
}

extension URLSession: ConcurrencyFetch {
    public func fetch<T: Decodable>(
        _ request: URLRequest,
        type: T.Type,
        decoder: JSONDecoder = .init(),
        delegate: URLSessionTaskDelegate? = nil
    ) -> Task<T, Error> {
        Task {
            let (decodable, response) = try await data(for: request, delegate: delegate)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try decoder.decode(T.self, from: decodable)
        }
    }
}
