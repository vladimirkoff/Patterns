
import UIKit

extension UIVisualEffectView {
    static func createBlur() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.0
        return view
    }
}
