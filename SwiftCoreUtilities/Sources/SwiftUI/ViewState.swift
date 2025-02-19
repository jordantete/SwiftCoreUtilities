import SwiftUI
import Combine

public enum ViewState {
    case idle
    case loading
    case success
    case error(String)
}

public final class ViewStateManager: ObservableObject {
    @Published public var state: ViewState = .idle
    
    public init() {}

    public func startLoading() {
        state = .loading
    }

    public func finishLoading() {
        state = .success
    }

    public func showError(_ message: String) {
        state = .error(message)
    }
}
