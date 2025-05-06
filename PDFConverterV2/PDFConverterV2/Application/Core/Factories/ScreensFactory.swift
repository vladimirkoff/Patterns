
import UIKit

@MainActor
final class ScreensFactory {
    static func makeLaunchScreen(transitions: Transitions, managersStorage: ManagersStorage) -> (controller: LaunchViewController, model: LaunchViewModel) {
        let viewModel = LaunchViewModel(transitions: transitions, managersStorage: managersStorage)
        let viewController = LaunchViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    static func makeApplicationScreen(transitions: Transitions, managersStorage: ManagersStorage) -> (controller: ApplicationViewController, model: ApplicationViewModel) {
        let viewModel = ApplicationViewModel(transitions: transitions, managersStorage: managersStorage)
        let viewController = ApplicationViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    static func makePDFScreen(transitions: Transitions, managersStorage: ManagersStorage, screenType: NavBarEnum, selectedImages: [UIImage]) -> (controller: PDFViewController, model: PDFViewModel) {
        let viewModel = PDFViewModel(transitions: transitions, managersStorage: managersStorage, selectedImages: selectedImages)
        let viewController = PDFViewController(viewModel: viewModel, screenType: screenType)
        return (viewController, viewModel)
    }
    
    static func makeSettingsScreen(transitions: Transitions, managersStorage: ManagersStorage) -> (controller: SettingsViewController, model: SettingsViewModel) {
        let viewModel = SettingsViewModel(transitions: transitions, managersStorage: managersStorage)
        let viewController = SettingsViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    static func makeDocumentScreen(transitions: Transitions, managersStorage: ManagersStorage, fileModel: FileModel) -> (controller: DocumentViewController, model: DocumentViewModel) {
        let viewModel = DocumentViewModel(transitions: transitions, managersStorage: managersStorage, fileModel: fileModel)
        let viewController = DocumentViewController(viewModel: viewModel)
        return (viewController, viewModel)
    }
}
