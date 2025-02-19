import Foundation
import StoreKit
import UIKit

public protocol AppStoreRatingService {
    func requestRating()
}

public final class AppStoreRatingServiceImpl: AppStoreRatingService {
    // MARK: - AppStoreRatingService

    public func requestRating() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: windowScene)
    }
}
