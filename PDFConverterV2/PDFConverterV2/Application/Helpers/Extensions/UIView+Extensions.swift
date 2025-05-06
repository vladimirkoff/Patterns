
import UIKit

extension UIView {
    static func createBackgroundView(with size: CGRect) -> UIView {
        let view = UIView(frame: size)
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }
}

extension UIView {
    func getImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
