import SwiftUI
import UIKit

public struct BlurEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    public init(style: UIBlurEffect.Style = .systemThinMaterial) {
        self.style = style
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
