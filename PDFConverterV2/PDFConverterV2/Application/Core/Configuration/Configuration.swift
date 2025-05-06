
import Foundation

struct Configuration {
    static var shared: Configuration?
    
    let apphudApiKey: String
}

struct ConfigurationSetter {
    static func readConfig() -> Configuration {
        Configuration(apphudApiKey: "app_9cMRXAtZVYXZAZkpb84TrSJy76fYCJ")
    }
}
