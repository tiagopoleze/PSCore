#if canImport(Combine)
import Combine
import Foundation

@available(iOS 13.0, macOS 10.15, *)
extension URLSession {
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
#endif
