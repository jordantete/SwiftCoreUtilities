import SwiftUI
import SwiftCoreUtilities

struct Feature: Identifiable {
    let id = UUID()
    let name: String
    let destination: () -> AnyView
}

struct FeatureListView: View {
    @StateObject private var coordinator = NavigationCoordinator<DemoRoute> { route in
        route.navigationStyle
    }
    
    private var features: [Feature] {
        [
            Feature(
                name: "Keyboard Dismiss Helper",
                destination: { AnyView(KeyboardDismissDemoView()) }
            ),
            Feature(
                name: "Shake Animation",
                destination: { AnyView(ShakeEffectDemoView()) }
            ),
            Feature(
                name: "Pulsating Effect",
                destination: { AnyView(PulsatingEffectDemoView()) }
            ),
            Feature(
                name: "Permission Management",
                destination: { AnyView(PermissionDemoView()) }
            ),
            Feature(
                name: "Navigation (Coordinator)",
                destination: { AnyView(DemoCoordinatorContainerView()) }
            )
        ]
    }

    var body: some View {
        NavigationView {
            List(features) { feature in
                NavigationLink(destination: feature.destination) {
                    Text(feature.name)
                }
            }
            .navigationTitle("SwiftCoreUtilities Demo")
        }
    }
}
