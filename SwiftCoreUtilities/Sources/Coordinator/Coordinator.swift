import SwiftUI

public protocol Route: Identifiable, Hashable {}

public enum NavigationStyle {
    case push
    case sheet
    case fullScreenCover
    case modal
    case custom((AnyView) -> AnyView)
}

public class NavigationCoordinator<RouteType: Route>: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var sheet: RouteType?
    @Published public var fullScreenCover: RouteType?
    @Published public var modal: RouteType?

    private let styleProvider: (RouteType) -> NavigationStyle

    public init(styleProvider: @escaping (RouteType) -> NavigationStyle = { _ in .push }) {
        self.styleProvider = styleProvider
    }

    public func navigate(to route: RouteType) {
        switch styleProvider(route) {
        case .push:
            path.append(route)
        case .sheet:
            sheet = route
        case .fullScreenCover:
            fullScreenCover = route
        case .modal:
            modal = route
        case .custom:
            path.append(route) // Handle custom if needed
        }
    }

    public func dismissCurrent() {
        if sheet != nil {
            sheet = nil
        } else if fullScreenCover != nil {
            fullScreenCover = nil
        } else if modal != nil {
            modal = nil
        }
    }

    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    public func reset() {
        path = NavigationPath()
    }
}
