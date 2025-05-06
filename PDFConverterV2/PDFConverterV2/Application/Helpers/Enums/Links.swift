
import Foundation

enum Link {
    case privacyPolicy
    case termsOfUse

    var url: URL? {
        switch self {
        case .privacyPolicy:
            return URL(string: "https://docs.google.com/document/d/1lGz5PDP4erLXU6SUy_PxVTqwFslCvic1YOIo3rrVYvo/edit?usp=sharing")
        case .termsOfUse:
            return URL(string: "https://docs.google.com/document/d/1wLjMGkJMRQQ68cxqMhU66NbKqbxitIYLST1aALs7n30/edit?usp=sharing")
        }
    }
}
