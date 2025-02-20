import Foundation
@testable import SwiftCoreUtilities

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let data = mockData, let response = mockResponse else {
            throw NetworkError.noResponse
        }
        return (data, response)
    }
}

struct MockResponse: Codable {
    let success: Bool
}
