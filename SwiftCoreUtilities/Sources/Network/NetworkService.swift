import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ request: APIRequest, expecting: T.Type) async throws -> T
    func request(_ request: APIRequest) async throws
}

final class NetworkServiceImpl: NetworkService {
    // MARK: - Private properties
    
    private let session: URLSessionProtocol
    private let requestBuilder: NetworkRequestBuilder
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(
        session: URLSessionProtocol = URLSession.shared,
        requestBuilder: NetworkRequestBuilder = NetworkRequestBuilderImpl(),
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Generic Request (Decodable Response)
    
    func request<T: Decodable>(_ request: APIRequest, expecting: T.Type) async throws -> T {
        let urlRequest = try requestBuilder.buildUrlRequest(for: request)

        do {
            let (data, response) = try await session.data(for: urlRequest)
            try validateResponse(response)
            LogManager.info("Response received for \(request.method.rawValue) \(request.url): \(data.count) bytes")
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            LogManager.error("Decoding failed: \(error.localizedDescription)")
            throw NetworkError.from(error)
        }
    }
    
    // MARK: - Request Without Response (POST)
    
    func request(_ request: APIRequest) async throws {
        let urlRequest = try requestBuilder.buildUrlRequest(for: request)
        
        do {
            let (_, response) = try await session.data(for: urlRequest)
            try validateResponse(response)
            LogManager.info("Successfully sent \(request.method.rawValue) request to \(request.url)")
        } catch {
            LogManager.error("Network request failed: \(error.localizedDescription)")
            throw NetworkError.from(error)
        }
    }
    
    // MARK: - Private Methods
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
}
