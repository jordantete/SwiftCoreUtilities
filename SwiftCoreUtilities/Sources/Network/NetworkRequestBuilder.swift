import Foundation

protocol NetworkRequestBuilder {
    func buildUrlRequest(for request: APIRequest) throws -> URLRequest
}

final class NetworkRequestBuilderImpl: NetworkRequestBuilder {
    func buildUrlRequest(for request: APIRequest) throws -> URLRequest {
        LogManager.info("Building request for URL: \(request.url)")
        
        guard let url = URL(string: request.url) else {
            LogManager.error("Invalid URL: \(request.url)")
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
                LogManager.info("Request body successfully encoded")
            } catch {
                LogManager.error("Failed to encode request body: \(error.localizedDescription)")
                throw NetworkError.encodingFailed
            }
        }
        
        LogManager.info("Successfully built request: \(urlRequest.httpMethod ?? "UNKNOWN") \(url.absoluteString)")
        return urlRequest
    }
}
