
import UIKit
import MessageUI
import StoreKit

@MainActor
class Navigator: NSObject {
    
    private let window: UIWindow
   
    var managersStorage: ManagersStorage

    var navigationController: UINavigationController? {
        return viewController(controller: window.rootViewController)?.navigationController
    }
    
    var viewController: UIViewController? {
        return viewController(controller: window.rootViewController)
    }
    
    init(window: UIWindow) {
        self.window = window
        self.managersStorage = ManagersStorage()
        super.init()
        register()
    }
    
    func register() {}
    
    func setInitialController(_ controller: UIViewController) {
        window.rootViewController = controller
    }
    
    func presentViewController(_ controller: UIViewController, style: UIModalPresentationStyle = .currentContext) {
        controller.modalPresentationStyle = style
        navigationController?.present(controller, animated: true)
    }
    
    func pushViewController(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func viewController(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return viewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return viewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return viewController(controller: presented)
        }
        return controller
    }
}

extension Navigator: MFMailComposeViewControllerDelegate {
    
    private var email: String {
        "garettnor1kel2@gmail.com"
    }
    
    private var id: String {
        return "6480517501"
    }
    
    func submitRate() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func feedback() {
        guard MFMailComposeViewController.canSendMail() else { return }
        
        let viewController = MFMailComposeViewController()
        viewController.setToRecipients([email])
        viewController.mailComposeDelegate = self
        viewController.overrideUserInterfaceStyle = .light
        
        presentViewController(viewController, style: .automatic)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func share() {
        var activityItems = [Any]()
        
        guard let url = URL(string: "https://itunes.apple.com/app/\(id)") else { return }
        activityItems.append(url)
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        presentViewController(activityViewController)
        
        activityViewController.completionWithItemsHandler = { [weak self] _, success, _, _ in
            self?.viewController?.dismiss(animated: true)
        }
    }
    
    func showPrivacyPolicy() {
        guard let url = Link.privacyPolicy.url else { return }
        UIApplication.shared.open(url)
    }
    
    func showTermsOfUse() {
        guard let url = Link.termsOfUse.url else { return }
        UIApplication.shared.open(url)
    }
    
    func review() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/\(id)?action=write-review")!)
    }
}
