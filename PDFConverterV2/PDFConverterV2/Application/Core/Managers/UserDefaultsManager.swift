
import Foundation

final class UserDefaultsManager: StorageItem {
    
    private let userDefaults = UserDefaults.standard
    
    var isFirstPhotoConvertation: Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.isFirstPhotoConvertation.rawValue)
    }
    
    var isFirstScan: Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.isFirstScan.rawValue)
    }
    
    var isFreeFunctionalityPassed: Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.hadOneConvertation.rawValue)
    }
    
    enum UserDefaultsKeys: String {
        case isOnboardingPassed = "isOnboardingPassed"
        case hadOneConvertation = "hadOneConvertation"
        case isFirstPhotoConvertation = "isFirstPhotoConvertation"
        case isFirstScan = "isFirstScan"
    }
    
    func onboardingPassed() {
        userDefaults.setValue(true, forKey: UserDefaultsKeys.isOnboardingPassed.rawValue)
    }
    
    func isOnboardingPassed() -> Bool {
        userDefaults.bool(forKey: UserDefaultsKeys.isOnboardingPassed.rawValue)
    }
    
    func setFreeFunctionalityPassed() {
        userDefaults.setValue(true, forKey: UserDefaultsKeys.hadOneConvertation.rawValue)
    }
    
    func setFirstScan() {
        userDefaults.setValue(true, forKey: UserDefaultsKeys.isFirstScan.rawValue)
    }
    
    func setFirstPhotoConvertation() {
        userDefaults.setValue(true, forKey: UserDefaultsKeys.isFirstPhotoConvertation.rawValue)
    }
}
