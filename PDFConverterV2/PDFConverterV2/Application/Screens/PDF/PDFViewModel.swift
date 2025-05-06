
import UIKit.UIImage
import RxSwift
import RxCocoa

@MainActor
final class PDFViewModel {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, FileItem>
    
    private let disposeBag = DisposeBag()
    
    var currentPage = 0
    var selectedImages: [UIImage]
    
    private let transitions: Transitions
    private let managersStorage: ManagersStorage
    private let imageConverterManager: ImageConverterManager
    private let realmManager = RealmManager.shared
    private let userDefaultsManager: UserDefaultsManager
    
    private(set) var snapshotRelay = BehaviorRelay<Snapshot?>.init(value: nil)
    private(set) var counterRelay = BehaviorRelay<Int?>.init(value: nil)
    private(set) var dataRelay = BehaviorRelay<Data?>.init(value: nil)
    private(set) var sizeExceededRelay = BehaviorRelay<Void?>.init(value: nil)
    
    var isFirstScan: Bool {
        userDefaultsManager.isFirstScan
    }
    
    var isFirstPhotoConvertation: Bool {
        userDefaultsManager.isFirstPhotoConvertation
    }
    
    var isFreeFunctionalityPassed: Bool {
        userDefaultsManager.isFreeFunctionalityPassed
    }
    
    init(transitions: Transitions, managersStorage: ManagersStorage, selectedImages: [UIImage]) {
        self.transitions = transitions
        self.managersStorage = managersStorage
        self.imageConverterManager = managersStorage.recieve(managerType: ImageConverterManager.self)
        self.selectedImages = selectedImages
        self.userDefaultsManager = managersStorage.recieve(managerType: UserDefaultsManager.self)
        
        configureSnapshot(with: selectedImages.map {FileItem(image: $0)})
        bind()
    }
    
    func pop() {
        transitions.pop()
    }
    
    func addImage(image: UIImage) {
        selectedImages.append(image)
        configureSnapshot(with: selectedImages.map {FileItem(image: $0)})
    }
    
    func convertImagesToPDF(for type: NavBarEnum) {
        let prefix = type == .scanner ? R.string.localizable.scanner() : R.string.localizable.image()
        let name = "\(prefix) - \(Int.generateRandomNumber())"
        guard let pdfData = imageConverterManager.convertImageToPDF(images: selectedImages),
              let imageCoverData = selectedImages.first?.jpegData(compressionQuality: 0.8)
        else { return }
        dataRelay.accept(pdfData)
        let document = DocumentBuilder()
            .setName(name)
            .setDate(Date())
            .setPDF(pdfData)
            .setImageCoverData(imageCoverData)
            .setId(UUID().uuidString)
            .build()
        realmManager.saveDocument(document: document)
    }
    
    func startProgress(completion: @escaping(Timer) -> ()) {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: completion)
    }
    
    func setFirstConvertation(screenType: NavBarEnum) {
        switch screenType {
        case .photoPDF:
            userDefaultsManager.setFirstPhotoConvertation()
        case .scanner:
            userDefaultsManager.setFirstScan()
        default:
            break
        }
    }
    
    func setFreeFunctionalityPassed() {
        userDefaultsManager.setFreeFunctionalityPassed()
    }
}

// MARK: Private  methods

private extension PDFViewModel {
    func configureSnapshot(with items: [FileItem]) {
        counterRelay.accept(items.count)
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        snapshotRelay.accept(snapshot)
    }
    
    func bind() {
        realmManager.errorRelay
            .asDriver()
            .compactMap({$0})
            .drive(onNext: { [weak self] toShowError in
                guard toShowError else { return }
                self?.sizeExceededRelay.accept(())
            }).disposed(by: disposeBag)
    }
}
