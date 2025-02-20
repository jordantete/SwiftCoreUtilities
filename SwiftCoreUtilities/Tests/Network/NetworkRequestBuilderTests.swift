import XCTest
@testable import SwiftCoreUtilities

final class NetworkRequestBuilderTests: XCTestCase {
    // MARK: - Private properties

    private var requestBuilder: NetworkRequestBuilderImpl!
    
    // MARK: - Initialization
    
    override func setUp() {
        super.setUp()
        requestBuilder = NetworkRequestBuilderImpl()
    }
    
    override func tearDown() {
        requestBuilder = nil
        super.tearDown()
    }
    
    // MARK: - Tests

    func testBuildUrlRequest_WithValidURL_ReturnsCorrectRequest() throws {
        // Given
        let apiRequest = APIRequest(url: "https://example.com", method: .get, headers: nil, body: nil)
        
        // When
        let urlRequest = try requestBuilder.buildUrlRequest(for: apiRequest)
        
        // Then
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://example.com")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertTrue(urlRequest.allHTTPHeaderFields?.isEmpty ?? true)
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testBuildUrlRequest_WithInvalidURL_ThrowsError() {
        // Given
        let apiRequest = APIRequest(url: "invalid_url", method: .get, headers: nil, body: nil)
        
        // When
        XCTAssertThrowsError(try requestBuilder.buildUrlRequest(for: apiRequest)) { error in
            // Then
            XCTAssertEqual(error as? NetworkError, .invalidURL)
        }
    }
    
    func testBuildUrlRequest_WithHeaders_SetsHeadersCorrectly() throws {
        // Given
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer token"]
        let apiRequest = APIRequest(url: "https://example.com", method: .post, headers: headers, body: nil)
        
        // Given
        let urlRequest = try requestBuilder.buildUrlRequest(for: apiRequest)
        
        // Then
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, headers)
    }
    
    func testBuildUrlRequest_WithEncodableBody_EncodesCorrectly() throws {
        // Given
        struct MockBody: Encodable {
            let key: String
        }
        
        let mockBody = MockBody(key: "value")
        let apiRequest = APIRequest(url: "https://example.com", method: .post, headers: nil, body: mockBody)
        
        // When
        let urlRequest = try requestBuilder.buildUrlRequest(for: apiRequest)
        
        // Then
        let encodedData = try JSONEncoder().encode(mockBody)
        XCTAssertEqual(urlRequest.httpBody, encodedData)
    }
}
