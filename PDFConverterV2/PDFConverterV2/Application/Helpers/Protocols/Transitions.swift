
// MARK: Transitions

import UIKit

protocol Transitions: NSObject {
    func dismiss()
    func pop()
    func popToRoot()
    
    func feedback()
    func review()
    func share()
    func showPrivacyPolicy()
    func showTermsOfUse()
    func submitRate()
    
    func showLaucnh()
    func showApplication()
    func showSettings()
    func showPDF(screenType: NavBarEnum, selectedImages: [UIImage])
    func showDocument(fileModel: FileModel)
}
