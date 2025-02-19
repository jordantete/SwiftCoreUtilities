import SwiftUI

/// A modifier that applies a pulsating animation effect to a view.
public struct PulsatingEffect: ViewModifier {
    @State private var scale: CGFloat = 1.0

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: scale)
            .onAppear {
                scale = 1.2
            }
    }
}

/// A View extension to apply the pulsating effect.
public extension View {
    func pulsating() -> some View {
        self.modifier(PulsatingEffect())
    }
}
