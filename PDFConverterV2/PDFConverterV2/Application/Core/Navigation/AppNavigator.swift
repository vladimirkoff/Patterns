
import UIKit

final class AppNavigator: Navigator, Transitions {
    
    override func register() {
        super.register()
        managersStorage.register(manager: ManagersFactory.makeRealmManager())
        managersStorage.register(manager: ManagersFactory.makeImageConverterManager())
        managersStorage.register(manager: ManagersFactory.makeUserDefaultsManager())
        managersStorage.register(manager: ManagersFactory.makeFilesSystemManager())
    }
    
    func showLaucnh() {
        let viewController = ScreensFactory.makeLaunchScreen(transitions: self, managersStorage: managersStorage).controller
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        setInitialController(navigationController)
    }
    
    func showApplication() {
        let viewController = ScreensFactory.makeApplicationScreen(transitions: self, managersStorage: managersStorage).controller
        let navigationController = UINavigationController(rootViewController: viewController)
        setInitialController(navigationController)
    }
    
    func showPDF(screenType: NavBarEnum, selectedImages: [UIImage]) {
        let viewController = ScreensFactory.makePDFScreen(transitions: self, managersStorage: managersStorage, screenType: screenType, selectedImages: selectedImages).controller
        pushViewController(viewController)
    }
    
    func showSettings() {
        let viewController = ScreensFactory.makeSettingsScreen(transitions: self, managersStorage: managersStorage).controller
        pushViewController(viewController)
    }
    
    func showDocument(fileModel: FileModel) {
        let viewController = ScreensFactory.makeDocumentScreen(transitions: self, managersStorage: managersStorage, fileModel: fileModel).controller
        pushViewController(viewController)
    }
}
