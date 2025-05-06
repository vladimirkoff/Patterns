
import Foundation

final class LaunchViewModel {
    
    private let transitions: Transitions
    private let userDefaultsManager: UserDefaultsManager
    
    init(transitions: Transitions, managersStorage: ManagersStorage) {
        self.transitions = transitions
        self.userDefaultsManager = managersStorage.recieve(managerType: UserDefaultsManager.self)
    }
    
    func showApplication() {
        DispatchQueue.main.async { [weak self] in
            self?.transitions.showApplication()
        }
    }
}
