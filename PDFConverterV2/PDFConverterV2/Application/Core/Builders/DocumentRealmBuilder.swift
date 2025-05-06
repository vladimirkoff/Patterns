
import Foundation

class DocumentRealmBuilder {
    private var name: String = ""
    private var date: Date = Date()
    private var pdf: Data = Data()
    private var imageCoverData: Data = Data()
    private var id: String = ""
    
    func setName(_ name: String) -> DocumentRealmBuilder {
        self.name = name
        return self
    }
    
    func setDate(_ date: Date) -> DocumentRealmBuilder {
        self.date = date
        return self
    }
    
    func setPDF(_ pdf: Data) -> DocumentRealmBuilder {
        self.pdf = pdf
        return self
    }
    
    func setImageCoverData(_ imageCoverData: Data) -> DocumentRealmBuilder {
        self.imageCoverData = imageCoverData
        return self
    }
    
    func setId(_ id: String) -> DocumentRealmBuilder {
        self.id = id
        return self
    }
    
    func build() -> DocumentRealm {
        return DocumentRealm(name: name, date: date, pdf: pdf, imageCoverData: imageCoverData, id: id)
    }
}
