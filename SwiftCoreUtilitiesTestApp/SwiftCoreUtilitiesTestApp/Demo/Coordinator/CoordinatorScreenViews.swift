import SwiftUI
import SwiftCoreUtilities

struct FirstScreenView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator<DemoRoute>

    var body: some View {
        VStack(spacing: 20) {
            Text("📱 First Screen")
                .font(.largeTitle)

            Button("Present Second as Sheet") {
                coordinator.navigate(to: .secondScreen(message: "Hello from First!"))
            }
        }
        .padding()
    }
}

struct SecondScreenView: View {
    let message: String
    @EnvironmentObject var coordinator: NavigationCoordinator<DemoRoute>

    var body: some View {
        VStack(spacing: 20) {
            Text("📄 Second Screen")
                .font(.title)
            Text(message)
                .foregroundColor(.secondary)

            Button("Dismiss") {
                coordinator.dismissCurrent()
            }
        }
        .padding()
    }
}
