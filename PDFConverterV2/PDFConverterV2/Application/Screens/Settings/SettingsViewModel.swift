
import Foundation
import RxRelay

@MainActor
final class SettingsViewModel {
    
    private let transitions: Transitions
    private let managersStorage: ManagersStorage
    
    private(set) var showPremiumRelay = BehaviorRelay<Bool>.init(value: false)
    
    init(transitions: Transitions, managersStorage: ManagersStorage) {
        self.transitions = transitions
        self.managersStorage = managersStorage
    }
    
    func goBack() {
        transitions.pop()
    }
    
    func transition(for tag: Int) {
        switch tag {
        case 0:
            transitions.feedback()
        case 1:
            transitions.review()
        case 2:
            transitions.share()
        case 3:
            transitions.showPrivacyPolicy()
        case 4:
            transitions.showTermsOfUse()
        default:
            break
        }
    }
}
