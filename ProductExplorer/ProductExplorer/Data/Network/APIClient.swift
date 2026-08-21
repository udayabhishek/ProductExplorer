import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

/// Thin, generic networking wrapper. Nothing product-specific lives here,
/// so it can be reused for any future endpoint.
final class APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError.requestFailed(error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.requestFailed("Unexpected server response")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}
