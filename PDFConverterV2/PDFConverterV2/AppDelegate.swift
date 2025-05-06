
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var appWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        return window
    }()
    
    private lazy var appNavigator = AppNavigator(window: appWindow)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Configuration.shared = ConfigurationSetter.readConfig()
        appNavigator.showLaucnh()
        return true
    }

}

