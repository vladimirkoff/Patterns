
import Foundation
import UIKit.UIImage
import WebKit
import RxSwift
import RxCocoa

@MainActor
final class DocumentViewModel {
    
    let fileModel: FileModel
    
    private let disposeBag = DisposeBag()
    
    private let transitions: Transitions
    private let realmManager = RealmManager.shared
    private let userDefaultsManager: UserDefaultsManager
    private let imageConverterManager: ImageConverterManager
    
    private(set) var dataRelay = BehaviorRelay<Data?>.init(value: nil)
    private(set) var sizeExceededRelay = BehaviorRelay<Void?>.init(value: nil)
    
    var isFreeFunctionalityPassed: Bool {
        userDefaultsManager.isFreeFunctionalityPassed
    }
    
    init(transitions: Transitions, managersStorage: ManagersStorage, fileModel: FileModel) {
        self.transitions = transitions
        self.fileModel = fileModel
        self.userDefaultsManager = managersStorage.recieve(managerType: UserDefaultsManager.self)
        self.imageConverterManager = managersStorage.recieve(managerType: ImageConverterManager.self)
        
        bind()
    }
    
    func saveDocumentToPDF(pdfData: Data, webView: UIView) {
        guard let imageCoverData = webView.getImage().pngData() else { return }
        let name = "\(fileModel.fileName).pdf"
        let document = DocumentBuilder()
            .setName(name)
            .setDate(Date())
            .setPDF(pdfData)
            .setImageCoverData(imageCoverData)
            .setId(UUID().uuidString)
            .build()
        dataRelay.accept(pdfData)
        realmManager.saveDocument(document: document)
    }
    
    func startProgress(completion: @escaping(Timer) -> ()) {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: completion)
    }
    
    func pop() {
        transitions.pop()
    }
    
    func setFreeFunctionalityPassed() {
        userDefaultsManager.setFreeFunctionalityPassed()
    }
    
    func convertToPDF(from webView: WKWebView) {
        let convertedPDFData = imageConverterManager.convertImageFromWebView(webView: webView)
        saveDocumentToPDF(pdfData: convertedPDFData, webView: webView.scrollView)
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
