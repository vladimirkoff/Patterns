
import UIKit
import RealmSwift

class DocumentRealm: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var pdf: Data = Data()
    @objc dynamic var imageCoverData: Data = Data()
    @objc dynamic var id: String = ""

    convenience init(name: String, date: Date, pdf: Data, imageCoverData: Data, id: String) {
        self.init()
        self.name = name
        self.date = date
        self.pdf = pdf
        self.imageCoverData = imageCoverData
        self.id = id
    }
}
