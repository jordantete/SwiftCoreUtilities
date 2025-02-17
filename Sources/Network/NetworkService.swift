import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ request: APIRequest, expecting: T.Type) async throws -> T
    func request(_ request: APIRequest) async throws
}

final class NetworkServiceImpl: NetworkService {
    // MARK: - Private properties
    
    private let session: URLSession
    private let requestBuilder: NetworkRequestBuilder
    
    // MARK: - Initialization
    
    init(
        session: URLSession = .shared,
        requestBuilder: NetworkRequestBuilder = NetworkRequestBuilderImpl()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }
    
    // MARK: - Generic Request (Decodable Response)
    
    func request<T: Decodable>(_ request: APIRequest, expecting: T.Type) async throws -> T {
        let request = try requestBuilder.buildUrlRequest(for: request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            LogManager.info("Decoding response from data: \(data)")
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    // MARK: - Request Without Response (POST)
    
    func request(_ request: APIRequest) async throws {
        let request = try requestBuilder.buildUrlRequest(for: request)
        
        do {
            let (_, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }

            LogManager.info("Received response statusCode: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
        } catch {
            throw NetworkError.from(error)
        }
    }
}
