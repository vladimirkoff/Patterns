
import UIKit
import Feedbacks

class CollectionViewCell: UICollectionViewCell {
    
    private var isFeedbackActive: Bool { return true }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
    }
    
    func setupStyle() {}
    func arrangeSubviews() {}
    func setupViewConstraints() {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isFeedbackActive else { return }
        fck.scale(x: 0.96, y: 0.96)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        fck.hapticSelection()
        fck.identity()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard isFeedbackActive else { return }
        fck.identity()
    }
}
