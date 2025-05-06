
import UIKit
import Feedbacks

class Button: UIButton {
    
    var isScaleable: Bool = true

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isScaleable { fck.scale(x: 0.9, y: 0.9) }
        fck.hapticSelection()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isScaleable { fck.identity() }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if isScaleable { fck.identity() }
    }
}
