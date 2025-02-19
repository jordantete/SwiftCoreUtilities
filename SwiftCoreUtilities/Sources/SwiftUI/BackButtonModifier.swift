import SwiftUI

/// A modifier that allows customizing the navigation back button.
public struct BackButtonModifier: ViewModifier {
    let action: () -> Void

    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: action) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
    }
}

/// A  View extension to apply the back button modifier.
public extension View {
    func customBackButton(action: @escaping () -> Void) -> some View {
        self.modifier(BackButtonModifier(action: action))
    }
}
