
import UIKit

@MainActor
final class ManagersFactory {
    static func makeRealmManager() -> RealmManager { RealmManager() }
    static func makeImageConverterManager() -> ImageConverterManager { ImageConverterManager() }
    static func makeUserDefaultsManager() -> UserDefaultsManager { UserDefaultsManager() }
    static func makeFilesSystemManager() -> FileSystemManager { FileSystemManager() }
}
