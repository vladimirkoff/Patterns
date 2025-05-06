
import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
}
