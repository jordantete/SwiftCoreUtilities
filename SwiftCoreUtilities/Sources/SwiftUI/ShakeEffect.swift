import SwiftUI

/// A modifier that applies a shake animation to a view when triggered.
public struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakes: Int = 3
    public var animatableData: CGFloat

    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakes)), y: 0))
    }
}

/// A View extension to apply the shake effect.
public extension View {
    func shake(_ times: CGFloat) -> some View {
        modifier(ShakeEffect(animatableData: times))
    }
}
