import XCTest
import CoreMotion
@testable import SwiftCoreUtilities

final class MotionManagerTests: XCTestCase {
    // MARK: - Private properties
    
    private var motionManager: MotionManagerImpl!
    private var mockCMMotionManager: MockCMMotionManager!
    private var mockDelegate: MockMotionManagerDelegate!
    
    // MARK: - Initialization
    
    override func setUp() {
        super.setUp()
        mockCMMotionManager = MockCMMotionManager()
        mockDelegate = MockMotionManagerDelegate()
        motionManager = MotionManagerImpl(accelerometerUpdateInterval: 0.5, motionManager: mockCMMotionManager)
        motionManager.delegate = mockDelegate
    }
    
    override func tearDown() {
        motionManager = nil
        mockCMMotionManager = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testStartAccelerometerUpdates_WhenAccelerometerUnavailable_DoesNotStart() {
        // Given
        mockCMMotionManager.isAccelerometerAvailableMock = false
        
        
        // When
        motionManager.startAccelerometerUpdates()
        
        
        // Then
        XCTAssertFalse(mockDelegate.didUpdateAccelerationCalled)
        XCTAssertFalse(mockDelegate.didFailWithErrorCalled)
    }
    
    func testStartAccelerometerUpdates_WhenAccelerometerAvailable_ReceivesAcceleration() {
        // Given
        mockCMMotionManager.isAccelerometerAvailableMock = true
        mockCMMotionManager.mockAcceleration = CMAcceleration(x: 1.0, y: -1.0, z: 0.5)
        
        let expectation = expectation(description: "Wait for acceleration update")
        mockDelegate.didUpdateAccelerationHandler = { expectation.fulfill() }
        
        // When
        motionManager.startAccelerometerUpdates()
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertTrue(mockDelegate.didUpdateAccelerationCalled)
        XCTAssertEqual(mockDelegate.receivedAcceleration?.x, 1.0)
        XCTAssertEqual(mockDelegate.receivedAcceleration?.y, -1.0)
        XCTAssertEqual(mockDelegate.receivedAcceleration?.z, 0.5)
    }
    
    func testStartAccelerometerUpdates_WhenErrorOccurs_CallsDelegateWithError() {
        // Given
        let testError = NSError(domain: "TestError", code: 123, userInfo: nil)
        mockCMMotionManager.isAccelerometerAvailableMock = true
        mockCMMotionManager.error = testError // Simulate an error
        
        let expectation = expectation(description: "Wait for error callback")
        mockDelegate.didFailWithErrorHandler = { expectation.fulfill() }
        
        // When
        motionManager.startAccelerometerUpdates()
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertEqual(mockDelegate.receivedError, .unknown(testError))
    }
    
    func testStartAccelerometerUpdates_WhenNoAccelerationData_CallsDelegateWithError() {
        // Given
        mockCMMotionManager.isAccelerometerAvailableMock = true
        mockCMMotionManager.mockAcceleration = nil // Simulate missing acceleration data
        
        let expectation = expectation(description: "Wait for error callback")
        mockDelegate.didFailWithErrorHandler = { expectation.fulfill() }
        
        // When
        motionManager.startAccelerometerUpdates()
        waitForExpectations(timeout: 1.0)
        
        // Then
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertEqual(mockDelegate.receivedError, .accelerometerUnavailable)
    }
    
    func testStopAccelerometerUpdates() {
        // Given
        motionManager.startAccelerometerUpdates()
        
        // When
        motionManager.stopAccelerometerUpdates()
        
        // Then
        let latestAcceleration = motionManager.getLatestAcceleration()
        XCTAssertEqual(latestAcceleration.x, 0.0)
        XCTAssertEqual(latestAcceleration.y, 0.0)
        XCTAssertEqual(latestAcceleration.z, 0.0)
    }
    
    func testGetLatestAccelerationWithoutUpdate() {
        // When
        let latestAcceleration = motionManager.getLatestAcceleration()
        
        // Then (Default values)
        XCTAssertEqual(latestAcceleration.x, 0.0)
        XCTAssertEqual(latestAcceleration.y, 0.0)
        XCTAssertEqual(latestAcceleration.z, 0.0)
    }
}
