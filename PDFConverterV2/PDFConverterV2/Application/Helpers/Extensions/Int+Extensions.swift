
import Foundation

extension Int {
    static func generateRandomNumber() -> Int {
        Int(arc4random_uniform(90000) + 10000)
    }
}
