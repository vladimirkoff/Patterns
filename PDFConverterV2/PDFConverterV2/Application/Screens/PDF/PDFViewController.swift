
import UIKit
import PhotosUI
import WeScan
import QuickLook

struct FileItem: Hashable {
    let image: UIImage?
    let id = UUID().uuidString
}

final class PDFViewController: PDFBaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, FileItem>
    
    private let viewModel: PDFViewModel
    private let screenType: NavBarEnum
    
    private var previewController = QLPreviewController()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            return self?.configureCell(at: indexPath, image: item.image)
        }
        return dataSource
    }()
    
    // MARK: UI
    
    private let rateUsPopUp = RateUsPopUp(state: .rate)
    
    lazy var navBarView: NavBarView = {
        let view = NavBarView()
        view.configure(screenType: .photoPDF)
        return view
    }()
    
    private lazy var scannerViewController: ImageScannerController = {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        scannerViewController.navigationBar.tintColor = .white
        scannerViewController.modalPresentationStyle = .fullScreen
        return scannerViewController
    }()
    
    private var phPickerViewController: PHPickerViewController?
    
    // MARK: Lifecycle
    
    init(viewModel: PDFViewModel, screenType: NavBarEnum) {
        self.viewModel = viewModel
        self.screenType = screenType
        super.init()
        handleScreenType(screenType)
    }
    
    override func bind() {
        super.bind()
        
        let tapGesture = UITapGestureRecognizer()
        blurView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] recognizer in
                self?.showTip(toShow: false)
                self?.blurView.isUserInteractionEnabled = false
            })
            .disposed(by: disposeBag)
        
        navBarView.rx.backButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.pop()
            }).disposed(by: disposeBag)
        
        viewModel.counterRelay
            .asDriver()
            .compactMap({$0})
            .drive(onNext: { [weak self] count in
                guard let self else { return }
                self.counterLabel.text = "\(self.viewModel.currentPage + 1)/\(count)"
            }).disposed(by: disposeBag)
        
        navBarView.rx.rightBarButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                
                guard screenType == .photoPDF else {
                    self.present(self.scannerViewController, animated: true)
                    return
                }
                self.configurePHPicker()
                guard let phPickerViewController else { return }
                self.present(phPickerViewController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel.snapshotRelay
            .asDriver()
            .compactMap({$0})
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource.apply(snapshot)
            }).disposed(by: disposeBag)
        
        convertnButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }

                if !CacheManager.shared.isImagesRateUsShown {
                    showRateUs(toShow: true)
                    return
                }

                showLogicFlow()
            }).disposed(by: disposeBag)
        
        viewModel.sizeExceededRelay
            .asDriver()
            .compactMap({$0})
            .drive(onNext: { [weak self] in
                self?.alert.configure(with: .sizeExceeded)
                self?.showAlert(toShow: true)
            }).disposed(by: disposeBag)
        
        rateUsPopUp.rx.submitButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] state in
                if state == .rate {
                    self?.rateUsPopUp.configure(state: .thankYou)
                } else {
                    self?.review()
                }
            }).disposed(by: disposeBag)
        
        rateUsPopUp.rx.notNowButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showRateUs(toShow: false)
            }).disposed(by: disposeBag)
        
        alert.delegate = self
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        view.addSubview(navBarView)
        view.addSubview(collectionView)
        view.addSubview(counterLabel)
        view.addSubview(convertnButton)
        view.addSubview(pdfImage)
        view.addSubview(convertingLabel)
        view.addSubview(percentLabel)
        view.addSubview(progressView)
        view.addSubview(blurView)
        view.addSubview(alert)
        view.addSubview(tipLabel)
        view.addSubview(arrowImageView)
        view.addSubview(selectedPlusImageView)
        view.addSubview(rateUsPopUp)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedPlusImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.leading.equalTo(arrowImageView.snp.trailing).offset(5)
            make.size.equalTo(80)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tipLabel.snp.centerY)
            make.leading.equalTo(tipLabel.snp.trailing).offset(5)
            make.size.equalTo(24)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(80)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.leading.equalTo(32)
        }
        
        navBarView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIDevice.hasNotch ? 160 : 120)
        }
        
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBarView.snp.bottom).offset(UIDevice.hasNotch ? 26 : 12)
            make.width.equalTo(60)
            make.height.equalTo(28)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(convertnButton.snp.top).offset(UIDevice.hasNotch ? -28 : -14)
            make.height.equalTo(view.bounds.height / 1.69)
        }
        
        convertnButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
            make.bottom.equalTo(UIDevice.hasNotch ? -40 : -30)
        }
        
        pdfImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.size.equalTo(110)
        }
        
        convertingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pdfImage.snp.bottom).offset(12)
        }
        
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(percentLabel.snp.bottom).offset(12)
            make.width.equalTo(310)
            make.height.equalTo(12)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(convertingLabel.snp.bottom).offset(12)
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alert.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(265)
        }
        
        rateUsPopUp.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(297)
        }
    }
}

// MARK: Private methods

private extension PDFViewController {
    func showLogicFlow() {
        showProcessing(toShow: true)
        startProgressView()
    }
    
    func review() {
        guard let url = URL(string: "https://apps.apple.com/app/6480517501?action=write-review") else { return }
        UIApplication.shared.open(url)
        showRateUs(toShow: false)
    }
    
    func showRateUs(toShow: Bool) {
        toShow ? blurView.show() : blurView.hide()
        toShow ? rateUsPopUp.show() : rateUsPopUp.hide()
        toShow ? CacheManager.shared.imagesRateUsPassed() : showLogicFlow()
    }
    
    func configurePHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        phPickerViewController = picker
    }
    
    func handleScreenType(_ screenType: NavBarEnum) {
        guard shouldShowTip(for: screenType)
        else { blurView.isUserInteractionEnabled = false; return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showTip(toShow: true)
            self.viewModel.setFirstConvertation(screenType: self.screenType)
        }
    }
    
    func shouldShowTip(for screenType: NavBarEnum) -> Bool {
        switch screenType {
        case .scanner:
            !viewModel.isFirstScan
        case .photoPDF:
            !viewModel.isFirstPhotoConvertation
        default:
            false
        }
    }
    
    func showTip(toShow: Bool) {
        toShow ? hidableTipViews.show() : hidableTipViews.hide()
    }
    
    func startProgressView() {
        navBarView.hideRightBarButton()
        viewModel.setFreeFunctionalityPassed()
        progressView.show()
        progressView.progress = 0.0
        
        var progress: Float = 0.0
        viewModel.startProgress { [weak self] timer in
            guard let self else { return }
            progress += 0.02
            self.progressView.progress = progress
            let percentage = Int(progress * 100)
            self.percentLabel.text = "\(percentage)%"
            
            if percentage >= 99 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.alert.configure(with: .pdfReady)
                    self.showAlert(toShow: true)
                    self.viewModel.convertImagesToPDF(for: self.screenType)
                }
            }
        }
    }
    
    func updateCounterLabelForVisibleCell() {
        guard let visibleIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        counterLabel.text = "\(visibleIndexPath.row + 1)/\(viewModel.counterRelay.value ?? 0)"
    }
    
    func configureCell(at indexPath: IndexPath, image: UIImage?) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FileCell.reuseIdentifier,
            for: indexPath) as? FileCell
        else { return nil }
        cell.configure(with: image)
        return cell
    }
}

// MARK: PHPickerViewControllerDelegate

extension PDFViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { [weak self] result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                guard let image = object as? UIImage else { return }
                self?.viewModel.addImage(image: image)
            }
        }
    }
}

// MARK: ImageScannerControllerDelegate

extension PDFViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.addImage(image: results.croppedScan.image)
            scanner.dismiss(animated: true)
        }
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
}

// MARK: UIScrollViewDelegate, UICollectionViewDelegate

extension PDFViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCounterLabelForVisibleCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { updateCounterLabelForVisibleCell() }
    }
}

// MARK: QLPreviewControllerDelegate & QLPreviewControllerDataSource

extension PDFViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { return 1 }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        PDFPreviewItem(data: viewModel.dataRelay.value ?? Data())
    }
}

extension PDFViewController: AlertDelegate {
    func selectedButtonTapped() {
        viewModel.pop()
        blurView.hide()
    }
    
    func buttonTapped() {
        previewController.dataSource = self
        previewController.delegate = self
        present(previewController, animated: true, completion: nil)
    }
}
