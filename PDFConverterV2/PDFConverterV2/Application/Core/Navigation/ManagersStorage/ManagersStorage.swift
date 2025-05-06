
import Foundation

protocol StorageItem {}

final class ManagersStorage {
    private var container: [StorageItem] = []
    
    func register(manager: StorageItem) {
        for item in container {
            if type(of: item) == type(of: manager) {
                fatalError("Manager (\(manager.self)) has been already registered")
            }
        }
        container.append(manager)
    }
    
    func recieve<T: StorageItem>(managerType: T.Type) -> T {
        for item in container {
            if type(of: item) == managerType {
                if let content = item as? T {
                    return content
                } else {
                    fatalError("Fatal error when extracting manager (\(managerType))")
                }
            }
        }
        fatalError("Manager (\(managerType)) has not been registered")
    }
}
