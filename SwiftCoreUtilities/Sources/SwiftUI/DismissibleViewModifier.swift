import SwiftUI

/// A view modifier that enables drag-to-dismiss for full-screen covers.
public struct DismissibleViewModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode

    public func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onEnded { value in
                if value.translation.height > 100 { // Drag down detected
                    presentationMode.wrappedValue.dismiss()
                }
            })
    }
}

/// A View extension to apply the dismissible behavior.
public extension View {
    func dismissible() -> some View {
        self.modifier(DismissibleViewModifier())
    }
}
