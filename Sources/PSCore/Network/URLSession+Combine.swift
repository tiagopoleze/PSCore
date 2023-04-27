//
//  URLSession+Combine.swift
//  
//
//  Created by Tiago Ferreira on 27/04/2023.
//

import Combine
import Foundation

public protocol CombineFetch {
    func fetch<T: Decodable, S: Scheduler>(
        _ url: URL,
        decoder: JSONDecoder,
        scheduler: S,
        ofType: T.Type
    ) -> AnyPublisher<T, Error>
}

extension URLSession: CombineFetch {
    public func fetch<T: Decodable, S: Scheduler>(
        _ url: URL,
        decoder: JSONDecoder = .init(),
        scheduler: S = DispatchQueue.main,
        ofType: T.Type
    ) -> AnyPublisher<T, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
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
