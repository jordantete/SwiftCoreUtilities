import SwiftUI
import SwiftCoreUtilities

struct DemoCoordinatorContainerView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<DemoRoute>

    var body: some View {
        CoordinatorView(
            coordinator: coordinator,
            root: { FirstScreenView() },
            destinationBuilder: { route in
                route.view(coordinator: coordinator)
            }
        )
    }
}
