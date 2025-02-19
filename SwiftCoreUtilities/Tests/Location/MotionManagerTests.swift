import XCTest
import CoreMotion
@testable import SwiftCoreUtilities

final class MotionManagerTests: XCTestCase {
    
    var mockMotionManager: MockCMMotionManager!
    var motionManager: MotionManagerImpl!

    override func setUp() {
        super.setUp()
        mockMotionManager = MockCMMotionManager()
        motionManager = MotionManagerImpl(accelerometerUpdateInterval: 0.1)
    }

    override func tearDown() {
        mockMotionManager = nil
        motionManager = nil
        super.tearDown()
    }

    func testStartAccelerometerUpdates() {
        // Given
        let testAcceleration = CMAcceleration(x: 1.0, y: 1.5, z: -0.5)
        mockMotionManager.mockAcceleration = testAcceleration
        
        // When
        motionManager.startAccelerometerUpdates()
        
        let expectation = XCTestExpectation(description: "Wait for accelerometer update")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Then
        let latestAcceleration = motionManager.getLatestAcceleration()
        XCTAssertEqual(latestAcceleration.x, testAcceleration.x, accuracy: 0.01)
        XCTAssertEqual(latestAcceleration.y, testAcceleration.y, accuracy: 0.01)
        XCTAssertEqual(latestAcceleration.z, testAcceleration.z, accuracy: 0.01)
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
