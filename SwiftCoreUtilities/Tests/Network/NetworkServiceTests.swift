import XCTest
@testable import SwiftCoreUtilities

final class NetworkServiceTests: XCTestCase {
    // MARK: - Private properties
    
    private var mockSession: MockURLSession!
    private var mockRequestBuilder: MockNetworkRequestBuilder!
    private var networkService: NetworkServiceImpl!
    
    // MARK: - Initialization
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockRequestBuilder = MockNetworkRequestBuilder()
        networkService = NetworkServiceImpl(session: mockSession, requestBuilder: mockRequestBuilder)
    }
    
    override func tearDown() {
        mockSession = nil
        mockRequestBuilder = nil
        networkService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testRequest_WhenGETRequestSucceeds_ReturnsDecodedObject() async throws {
        // Given
        let expectedData = try JSONEncoder().encode(MockResponse(success: true))
        mockSession.mockData = expectedData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)
        let apiRequest = APIRequest(url: "https://example.com", method: .get)
        
        // When
        let response: MockResponse = try await networkService.request(apiRequest, expecting: MockResponse.self)
        
        // Then
        XCTAssertTrue(response.success)
    }
    
    func testRequest_WhenPOSTRequestSucceeds_DoesNotThrow() async throws {
        // Given
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)
        let apiRequest = APIRequest(url: "https://example.com", method: .post)
        
        // When // Then
        try await networkService.request(apiRequest) // Should not throw
    }
    
    func testRequest_WhenInvalidURL_ThrowsInvalidURLError() async {
        // Given
        mockRequestBuilder.shouldThrowInvalidURL = true
        let apiRequest = APIRequest(url: "invalid_url", method: .get)
        
        do {
            // When
            let _ = try await networkService.request(apiRequest, expecting: MockResponse.self)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testRequest_WhenServerErrorOccurs_ThrowsServerError() async {
        // Given
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 500, httpVersion: nil, headerFields: nil)
        let apiRequest = APIRequest(url: "https://example.com", method: .get)
        
        do {
            // When
            _ = try await networkService.request(apiRequest, expecting: MockResponse.self)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .serverError(500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testRequest_WhenNoResponse_ThrowsNoResponseError() async {
        // Given
        mockSession.mockResponse = nil // No response provided
        let apiRequest = APIRequest(url: "https://example.com", method: .get)
        
        do {
            // When
            _ = try await networkService.request(apiRequest, expecting: MockResponse.self)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .noResponse)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testRequest_WhenDecodingFails_ThrowsDecodingError() async {
        // Given
        mockSession.mockData = Data() // Empty data that won't decode
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200, httpVersion: nil, headerFields: nil)
        let apiRequest = APIRequest(url: "https://example.com", method: .get)
        
        do {
            // When
            _ = try await networkService.request(apiRequest, expecting: MockResponse.self)
            XCTFail("Expected error but got success")
        } catch let error as NetworkError {
            // Then
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
