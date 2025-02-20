import Foundation
@testable import SwiftCoreUtilities

final class MockNetworkRequestBuilder: NetworkRequestBuilder {
    var shouldThrowInvalidURL = false
    
    func buildUrlRequest(for request: APIRequest) throws -> URLRequest {
        if shouldThrowInvalidURL {
            throw NetworkError.invalidURL
        }
        return URLRequest(url: URL(string: request.url)!)
    }
}
