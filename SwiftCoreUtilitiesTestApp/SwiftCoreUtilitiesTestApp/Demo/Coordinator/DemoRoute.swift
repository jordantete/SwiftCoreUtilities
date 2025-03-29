import SwiftCoreUtilities
import SwiftUI

enum DemoRoute: Route {
    case firstScreen
    case secondScreen(message: String)
    
    var id: String {
        switch self {
        case .firstScreen: return "firstScreen"
        case .secondScreen: return "secondScreen"
        }
    }

    @ViewBuilder
    func view(coordinator: NavigationCoordinator<Self>) -> some View {
        switch self {
        case .firstScreen:
            FirstScreenView()
        case .secondScreen(let message):
            SecondScreenView(message: message)
        }
    }

    var navigationStyle: NavigationStyle {
        switch self {
        case .firstScreen:
            return .push
        case .secondScreen:
            return .sheet
        }
    }
}
