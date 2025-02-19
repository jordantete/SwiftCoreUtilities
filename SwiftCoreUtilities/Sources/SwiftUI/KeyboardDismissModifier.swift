import SwiftUI

/// A modifier to dismiss the keyboard when tapping outside a text field.
public struct KeyboardDismissModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

/// A helper function to extend UIApplication for dismissing the keyboard.
public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/// A view extension to use the modifier easily.
public extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
