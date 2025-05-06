
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import WeScan
import PhotosUI
import MobileCoreServices

final class ApplicationViewController: ViewController, UINavigationControllerDelegate {
    
    private let viewModel: ApplicationViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Document>
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            return self?.configureCell(at: indexPath, item: item)
        }
        return dataSource
    }()
    
    private lazy var showBackgroundClosure: BoolClosure = { [weak self] forCollection in
        forCollection ? self?.collectionBlurView.show() : self?.blurView.show()
    }
    
    private lazy var hideBackgroundClosure: BoolClosure = { [weak self] forCollection in
        forCollection ? self?.collectionBlurView.hide() : self?.blurView.hide()
    }
    
    // MARK: UI
    
    private var presentedPhoPicker: PHPickerViewController?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: buildLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(DocumentCell.self)
        return collectionView
    }()
    
    private let navBarView: NavBarView = {
        let view = NavBarView()
        view.configure(screenType: .main)
        return view
    }()
    
    private let plusButton: MenuButton = {
        let btn = MenuButton(forCollectionView: false)
        btn.setBackgroundImage(R.image.images.application.add(), for: .normal)
        btn.setBackgroundImage(R.image.images.application.add(), for: .highlighted)
        btn.showsMenuAsPrimaryAction = true
        return btn
    }()
    
    private let blurView: UIVisualEffectView = .createBlur()
    private let alertBlurView: UIVisualEffectView = .createBlur()
    private let collectionBlurView: UIVisualEffectView = .createBlur()

    private let alert: Alert = {
        let alert = Alert()
        alert.configure(with: .delete)
        return alert
    }()
    
    private let noFilesAlert: Alert = {
        let alert = Alert()
        alert.configure(with: .noFiles)
        return alert
    }()
    
    private let imageSizeAlert: Alert = {
        let alert = Alert()
        alert.configure(with: .sizeExceeded)
        return alert
    }()
    // MARK: Lifecycle
    
    init(viewModel: ApplicationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: Helpers
    
    override func bind() {
        super.bind()
        setMenu()
        
        let tapGesture = UITapGestureRecognizer()
        blurView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert(toShow: false)
            })
            .disposed(by: disposeBag)
        
        navBarView.rx.rightBarButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.showSettings()
            }).disposed(by: disposeBag)
        
        viewModel.snapshotRelay
            .asDriver()
            .compactMap({$0})
            .drive(onNext: { [weak self] snapshot in
                snapshot.itemIdentifiers.isEmpty ? self?.noFilesAlert.show() : self?.noFilesAlert.hide()
                self?.dataSource.apply(snapshot)
            }).disposed(by: disposeBag)
        
        imageSizeAlert.selectedButton.addTarget(self, action: #selector(selectedTapped), for: .touchUpInside)
        
        plusButton.showBackgroundClosure = showBackgroundClosure
        plusButton.hideBackgroundClosure = hideBackgroundClosure
        
        alert.delegate = self
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        view.addSubview(navBarView)
        view.addSubview(collectionView)
        view.addSubview(noFilesAlert)
        view.addSubview(blurView)
        view.addSubview(plusButton)
        view.addSubview(collectionBlurView)
        view.addSubview(alert)
        view.addSubview(alertBlurView)
        view.addSubview(imageSizeAlert)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        imageSizeAlert.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(326)
        }
        
        noFilesAlert.snp.makeConstraints { make in
            make.width.equalTo(327)
            make.height.equalTo(169)
            make.center.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertBlurView.snp.makeConstraints({$0.edges.equalToSuperview()})
        
        collectionBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(navBarView.snp.bottom).offset(0)
        }
        
        navBarView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIDevice.hasNotch ? 160 : 120)
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.trailing.equalTo(-24)
            make.bottom.equalTo(-52)
        }
        
        alert.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(274)
        }
    }
    
    @objc private func selectedTapped() {
        showSizeExceededAlert(toShow: false)
    }
}

// MARK: Private methods

private extension ApplicationViewController {
    func showAlert(toShow: Bool) {
        toShow ? blurView.show() : blurView.hide()
        toShow ? alert.show() : alert.hide()
    }
    
    func configureCell(at indexPath: IndexPath, item: Document) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DocumentCell.reuseIdentifier,
            for: indexPath) as? DocumentCell
        else { return nil }
        cell.configure(document: item, showBackgroundClosure: showBackgroundClosure, hideBackgroundClosure: hideBackgroundClosure)
        cell.setMenu(menu: configureMenu(id: item.id))
        return cell
    }
    
    func buildLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2.5,
                                 height: view.frame.height / 3.56)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 24, left: 26, bottom: 0, right: 26)
        return layout
    }
    
    func setMenu() {
        let menu = UIMenu.createAddMenu { [weak self] in
            self?.presentScanner()
        } galleryAction: { [weak self] in
            guard let self else { return }
            let photoPicker = self.createPhotoPicker()
            self.presentedPhoPicker = photoPicker
            self.present(photoPicker, animated: true, completion: nil)
        } filesAction: { [weak self] in
            self?.openFile()
        }
        plusButton.menu = menu
    }
    
    func openFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: Constants.allowedFileFormats, in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func presentScanner() {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        scannerViewController.navigationBar.tintColor = .white
        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true)
    }
    
    func createPhotoPicker() -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
    
    func showSizeExceededAlert(toShow: Bool) {
        toShow ? alertBlurView.show() : alertBlurView.hide()
        toShow ? imageSizeAlert.show() : imageSizeAlert.hide()
    }
}

// MARK: ImageScannerControllerDelegate

extension ApplicationViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true) { [weak self] in
            self?.viewModel.goToPDF(screenType: .scanner, selectedImages: [results.croppedScan.image])
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
}

// MARK: PHPickerViewControllerDelegate

extension ApplicationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        checkImagesForSize(results: results) { [weak self] checkPassed in
            guard checkPassed else { self?.showSizeExceededAlert(toShow: true); return }
            
            var pickedImages = [UIImage]()
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let image = image as? UIImage else { return }
                    pickedImages.append(image)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.presentedPhoPicker = nil
                guard !pickedImages.isEmpty else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    DispatchQueue.main.async {
                        self?.viewModel.goToPDF(screenType: .photoPDF, selectedImages: pickedImages)
                    }
                }
            }
        }
    }
}

// MARK: UIMenu

private extension ApplicationViewController {
    func configureMenu(id: String) -> UIMenu {
        return UIMenu.createEditMenu { [weak self] in
            guard let self, let index = indexOfDocById(id: id) else { return }
            self.viewModel.saveToFiles(presenter: self, indexPath: IndexPath(row: index, section: 0))
        } deleteAction: { [weak self] in
            guard let self, let index = indexOfDocById(id: id) else { return }
            self.showAlert(toShow: true)
            self.viewModel.indexPath = IndexPath(row: index, section: 0)
        }
    }
    
    func checkImagesForSize(results: [PHPickerResult], completion: @escaping (Bool) -> ()) {
        let dispatchGroup = DispatchGroup()
        var isImageTooLarge = false
        
        for result in results {
            dispatchGroup.enter()
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
                defer {
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    print("Error loading file: \(error)")
                    return
                }
                
                guard let url = url else { return }
                
                do {
                    let fileSize = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int64
                    
                    if let fileSize = fileSize {
                        if fileSize > 15 * 1024 * 1024 {
                            isImageTooLarge = true
                            return
                        }
                    }
                } catch {
                    print("Error checking file size: \(error)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if isImageTooLarge {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func indexOfDocById(id: String) -> Int? {
        guard let pickedDoc = viewModel.documents.first(where: {$0.id == id}),
              let index = viewModel.documents.firstIndex(of: pickedDoc)
        else { return nil }
        return index
    }
}

// MARK: UIDocumentPickerDelegate

extension ApplicationViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else { return }
        let fileModel = FileModel(fileURL: fileURL, fileName: fileURL.lastPathComponent)
        viewModel.showDocument(fileModel: fileModel)
    }
}

extension ApplicationViewController: AlertDelegate {
    func selectedButtonTapped() {
        showAlert(toShow: false)
    }
    
    func buttonTapped() {
        guard let indexPath = viewModel.indexPath else { return }
        viewModel.deleteDocumentFromFiles(indexPath: indexPath)
        showAlert(toShow: false)
    }
}
