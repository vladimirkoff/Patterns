
import UIKit.UIImage
import RxCocoa
import RxSwift

final class ApplicationViewModel {
        
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Document>
    
    private let disposeBag = DisposeBag()
    
    private(set) var snapshotRelay = BehaviorRelay<Snapshot?>.init(value: nil)
    private(set) var documents: [Document] = []

    private let transitions: Transitions
    private let managersStorage: ManagersStorage
    private let realmManager: RealmManager
    private let fileSystemManager: FileSystemManager
    
    var indexPath: IndexPath?
    
    init(transitions: Transitions, managersStorage: ManagersStorage) {
        self.transitions = transitions
        self.managersStorage = managersStorage
        self.realmManager = managersStorage.recieve(managerType: RealmManager.self)
        self.fileSystemManager = managersStorage.recieve(managerType: FileSystemManager.self)
        
        getDocuments()
        bind()
    }
    
    func goToPDF(screenType: NavBarEnum, selectedImages: [UIImage]) {
        transitions.showPDF(screenType: screenType, selectedImages: selectedImages)
    }
    
    func saveToFiles(presenter: UIViewController, indexPath: IndexPath) {
        guard let item = snapshotRelay.value?.itemIdentifiers[indexPath.row],
              let fileURL = fileSystemManager.getSelectedFileURL(pdfData: item.pdf, fileName: "\(item.name).pdf")
        else { return }
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        presenter.present(activityViewController, animated: true, completion: nil)    }
    
    func deleteDocumentFromFiles(indexPath: IndexPath) {
        guard let item = snapshotRelay.value?.itemIdentifiers[indexPath.row] else { return }
        realmManager.deleteDocument(by: item.id)
        getDocuments()
    }
    
    func showSettings() {
        transitions.showSettings()
    }
    
    func showDocument(fileModel: FileModel) {
        transitions.showDocument(fileModel: fileModel)
    }
}

// MARK: Internal methods

private extension ApplicationViewModel {
    
    func getDocuments() {
        realmManager.getDocuments()
    }
    
    func configureSnapshot(with items: [Document]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        snapshotRelay.accept(snapshot)
    }
    
    func bind() {
        realmManager.documentsRelay
            .asDriver()
            .drive(onNext: { [weak self] documents in
                self?.documents = documents
                self?.configureSnapshot(with: documents)
            }).disposed(by: disposeBag)
    }
}

