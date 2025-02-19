import UIKit

public extension UIScreen {
    /// The width of the screen
    static var width: CGFloat { main.bounds.width }
    
    /// The height of the screen
    static var height: CGFloat { main.bounds.height }
    
    /// The screen scale factor
    static var scaleFactor: CGFloat { main.scale }
    
    /// Detects if the device has a smaller vertical height (<800px)
    static var isSmallVerticalHeight: Bool {
        let height = UIDevice.isLandscape ? main.bounds.width : main.bounds.height
        return height < 800
    }
}
