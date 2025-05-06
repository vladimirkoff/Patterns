
import UIKit

class View: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
    }
    
    @available(*, unavailable,
                message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    func setupStyle() {}
    
    func arrangeSubviews() {}
    
    func setupViewConstraints() {}
}

