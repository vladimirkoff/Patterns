
import Foundation

extension Data {
    func sizeInMB() -> Float {
        let fileSizeInBytes = Float(count)
        return fileSizeInBytes / (1024 * 1024)
    }
}
