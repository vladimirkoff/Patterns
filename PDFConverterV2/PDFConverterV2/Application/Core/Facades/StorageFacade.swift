
import Foundation

final class StorageFacade {
    
    private let userDefaultsManager: UserDefaultsManager
    private let realmManager: RealmManager
    
    init(userDefaultsManager: UserDefaultsManager, realmManager: RealmManager) {
        self.userDefaultsManager = userDefaultsManager
        self.realmManager = realmManager
    }
}
