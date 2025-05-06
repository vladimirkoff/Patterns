
import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    private let realm: Realm
    
    private(set) var documentsRelay = BehaviorRelay<[Document]>.init(value: [])
    private(set) var errorRelay = BehaviorRelay<Bool?>.init(value: nil)
    
    func getDocuments() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let documentsRealm = Array(self.realm.objects(DocumentRealm.self))
            let documents = documentsRealm.map {
                DocumentBuilder()
                    .setName($0.name)
                    .setDate($0.date)
                    .setPDF($0.pdf)
                    .setImageCoverData($0.imageCoverData)
                    .setId($0.id)
                    .build()
            }
            DispatchQueue.main.async {
                self.documentsRelay.accept(documents)
            }
        }
    }
    
    func saveDocument(document: Document) {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  document.pdf.sizeInMB() < 16.0
            else { self?.errorRelay.accept(true); self?.errorRelay.accept(nil); return }
            let documentRealm = DocumentRealmBuilder()
                .setName(document.name)
                .setDate(document.date)
                .setPDF(document.pdf)
                .setImageCoverData(document.imageCoverData)
                .setId(document.id)
                .build()
            documentsRelay.accept(documentsRelay.value + [document])
            try? self.realm.write({
                self.realm.add(documentRealm)
            })
        }
    }
    
    func deleteDocument(by id: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let documents = Array(self.realm.objects(DocumentRealm.self))
            let deletedDocument = documents.first { $0.id == id }
            guard let deletedDocument else { return }
            try? self.realm.write({
                self.realm.delete(deletedDocument)
            })
        }
    }
}
