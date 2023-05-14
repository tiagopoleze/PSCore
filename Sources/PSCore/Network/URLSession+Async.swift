import Foundation

extension URLSession {
    public func createTask<T: Decodable>(
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
