import SwiftUI
import SwiftCoreUtilities

struct Feature: Identifiable {
    let id = UUID()
    let name: String
    let destination: AnyView
}

struct FeatureListView: View {
    private let features: [Feature] = [
        Feature(name: "Keyboard Dismiss Helper", destination: AnyView(KeyboardDismissDemoView())),
        Feature(name: "Shake Animation", destination: AnyView(ShakeEffectDemoView())),
        Feature(name: "Pulsating Effect", destination: AnyView(PulsatingEffectDemoView()))
    ]

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
