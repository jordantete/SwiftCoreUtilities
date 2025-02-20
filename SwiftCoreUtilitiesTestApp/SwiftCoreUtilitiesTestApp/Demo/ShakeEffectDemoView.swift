import SwiftUI
import SwiftCoreUtilities

struct ShakeEffectDemoView: View {
    @State private var shakeTrigger: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("Tap the button to see the shake effect")
                .font(.headline)
                .padding()

            Button(action: {
                withAnimation(.default) { shakeTrigger += 1 }
            }) {
                Text("Shake Me!")
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .shake(shakeTrigger)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Shake Effect")
    }
}
