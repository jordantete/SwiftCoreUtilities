import SwiftUI
import SwiftCoreUtilities

struct KeyboardDismissDemoView: View {
    @State private var text = ""

    var body: some View {
        VStack {
            Text("Tap outside to dismiss keyboard")
                .font(.headline)
                .padding()

            TextField("Type something...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()
        }
        .dismissKeyboardOnTap()
        .navigationTitle("Dismiss Keyboard")
    }
}
