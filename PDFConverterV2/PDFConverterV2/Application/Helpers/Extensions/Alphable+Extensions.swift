//
//  Alphable.swift
//

import UIKit

protocol Alphable {
    func show(duration: Double, delay: Double, completion: VoidClosure?)
    func hide(duration: Double, delay: Double, completion: VoidClosure?)
}

enum AlphableConstants {
    static public let animationDuration = 0.2
    static public let animationDelay = 0.0
}

extension Alphable where Self: UIView {
    func show(duration: Double = AlphableConstants.animationDuration, delay: Double = AlphableConstants.animationDelay, completion: VoidClosure? = nil) {
        guard duration != 0 else {
            alpha = 1
            return
        }
        animateAlpha(to: 1, duration: duration, delay: delay, completion: completion)
    }
    
    func hide(duration: Double = AlphableConstants.animationDuration, delay: Double = AlphableConstants.animationDelay, completion: VoidClosure? = nil) {
        guard duration != 0 else {
            alpha = 0
            return
        }
        animateAlpha(to: 0, duration: duration, delay: delay, completion: completion)
    }
    
    func animateAlpha(to endValue: CGFloat, duration: Double, delay: Double, completion: VoidClosure? = nil) {
        UIView.animate(withDuration: duration, delay: delay, animations: { [weak self] in
            self?.alpha = endValue
        }, completion: { _ in
            completion?()
        })
    }
}

extension UIView: Alphable { }
