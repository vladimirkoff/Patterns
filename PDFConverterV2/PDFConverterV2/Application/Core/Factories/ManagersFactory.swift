
import UIKit

@MainActor
final class ManagersFactory {
    static func makeImageConverterManager() -> ImageConverterManager { ImageConverterManager() }
    static func makeUserDefaultsManager() -> UserDefaultsManager { UserDefaultsManager() }
}
