
import Foundation

extension Array where Element: Alphable {
    func show(duration: Double = AlphableConstants.animationDuration, delay: Double = AlphableConstants.animationDelay, completion: VoidClosure? = nil) {
        for (index, view) in self.enumerated() {
            if index == count - 1 {
                view.show(duration: duration, delay: delay, completion: completion)
            } else {
                view.show(duration: duration, delay: delay, completion: nil)
            }
        }
    }
    
    func hide(duration: Double = AlphableConstants.animationDuration, delay: Double = AlphableConstants.animationDelay, completion: VoidClosure? = nil) {
        for (index, view) in self.enumerated() {
            if index == count - 1 {
                view.hide(duration: duration, delay: delay, completion: completion)
            } else {
                view.hide(duration: duration, delay: delay, completion: nil)
            }
        }
    }
}

extension Array {
    func replacingLast(with element: Element) -> [Element] {
        guard !self.isEmpty else { return [] }
        var array = self
        
        array[array.index(before: array.endIndex)] = element
        return array
    }
}
