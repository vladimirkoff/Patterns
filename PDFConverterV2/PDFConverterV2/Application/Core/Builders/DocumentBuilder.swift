
import Foundation

final class DocumentBuilder {
    private var name: String = ""
    private var date: Date = Date()
    private var pdf: Data = Data()
    private var imageCoverData: Data = Data()
    private var id: String = ""
    
    func setName(_ name: String) -> DocumentBuilder {
        self.name = name
        return self
    }
    
    func setDate(_ date: Date) -> DocumentBuilder {
        self.date = date
        return self
    }
    
    func setPDF(_ pdf: Data) -> DocumentBuilder {
        self.pdf = pdf
        return self
    }
    
    func setImageCoverData(_ imageCoverData: Data) -> DocumentBuilder {
        self.imageCoverData = imageCoverData
        return self
    }
    
    func setId(_ id: String) -> DocumentBuilder {
        self.id = id
        return self
    }
    
    func build() -> Document {
        return Document(name: name, date: date, pdf: pdf, imageCoverData: imageCoverData, id: id)
    }
}
