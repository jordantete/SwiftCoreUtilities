import SwiftUI
import SwiftCoreUtilities

struct PulsatingEffectDemoView: View {
    var body: some View {
        VStack {
            Text("Pulsating Effect Demo")
                .font(.headline)
                .padding()

            Button(action: {}) {
                Text("Tap Me!")
                    .padding()
                    .frame(width: 200)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .pulsating()
            .padding()

            Spacer()
        }
        .navigationTitle("Pulsating Effect")
    }
}
