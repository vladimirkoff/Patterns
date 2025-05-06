
import Foundation

final class CacheManager {
    var isImagesRateUsShown = false
    var isFilesRateUsShown = false

    static let shared = CacheManager()
    private init() {}
    
    func imagesRateUsPassed() {
        isImagesRateUsShown = true
    }
    
    func filesRateUsPassed() {
        isFilesRateUsShown = true
    }
}
