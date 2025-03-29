import SwiftUI

public struct CoordinatorView<RouteType: Route>: View {
    @ObservedObject var coordinator: NavigationCoordinator<RouteType>
    let root: () -> AnyView
    let destinationBuilder: (RouteType) -> AnyView

    public init(
        coordinator: NavigationCoordinator<RouteType>,
        root: @escaping () -> some View,
        destinationBuilder: @escaping (RouteType) -> some View
    ) {
        self.coordinator = coordinator
        self.root = { AnyView(root()) }
        self.destinationBuilder = { AnyView(destinationBuilder($0)) }
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            root()
                .navigationDestination(for: RouteType.self) { route in
                    destinationBuilder(route)
                }
        }
        .sheet(item: $coordinator.sheet) { destinationBuilder($0) }
        .fullScreenCover(item: $coordinator.fullScreenCover) { destinationBuilder($0) }
        .overlay(
            coordinator.modal.map { route in
                destinationBuilder(route)
            }
        )
    }
}
