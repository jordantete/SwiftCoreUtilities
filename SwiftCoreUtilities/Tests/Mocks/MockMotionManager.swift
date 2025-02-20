import XCTest
import CoreMotion
@testable import SwiftCoreUtilities

final class MockCMMotionManager: CMMotionManager {
    var isAccelerometerAvailableMock = true
    var mockAcceleration: CMAcceleration?
    var error: Error?

    override var isAccelerometerAvailable: Bool {
        isAccelerometerAvailableMock
    }
    
    override func startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler) {
        guard isAccelerometerAvailableMock else {
            handler(nil, NSError(domain: "CMMotionManager", code: 1, userInfo: nil))
            return
        }

        if let error = error {
            handler(nil, error)
        } else if let acceleration = mockAcceleration {
            handler(CMAccelerometerDataMock(acceleration: acceleration), nil)
        } else {
            handler(nil, nil) // Simulate no acceleration data
        }
    }
    
    override func stopAccelerometerUpdates() {
        mockAcceleration = nil
        error = nil
    }
}

final class MockMotionManagerDelegate: MotionManagerDelegate {
    var didUpdateAccelerationCalled = false
    var receivedAcceleration: CMAcceleration?
    
    var didFailWithErrorCalled = false
    var receivedError: MotionManagerError?
    
    var didUpdateAccelerationHandler: (() -> Void)?
    var didFailWithErrorHandler: (() -> Void)?

    func didUpdateAcceleration(_ acceleration: CMAcceleration) {
        didUpdateAccelerationCalled = true
        receivedAcceleration = acceleration
        didUpdateAccelerationHandler?()
    }

    func didFailWithError(_ error: MotionManagerError) {
        didFailWithErrorCalled = true
        receivedError = error
        didFailWithErrorHandler?()
    }
}

final class CMAccelerometerDataMock: CMAccelerometerData {
    private let _acceleration: CMAcceleration

    init(acceleration: CMAcceleration) {
        self._acceleration = acceleration
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceleration: CMAcceleration {
        return _acceleration
    }
}
