
import UIKit
import WebKit
import QuickLook

final class DocumentViewController: PDFBaseViewController {
    
    private let previewController = QLPreviewController()
    private let viewModel: DocumentViewModel
    
    // MARK: UI
    
    private let rateUsPopUp = RateUsPopUp(state: .rate)
    
    lazy var navBarView: NavBarView = {
        let view = NavBarView()
        view.configure(screenType: .filePDF)
        return view
    }()
    
    init(viewModel: DocumentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        view.addSubview(webView)
        view.addSubview(navBarView)
        view.addSubview(convertnButton)
        view.addSubview(pdfImage)
        view.addSubview(convertingLabel)
        view.addSubview(percentLabel)
        view.addSubview(progressView)
        view.addSubview(blurView)
        view.addSubview(alert)
        view.addSubview(rateUsPopUp)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        convertnButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
            make.bottom.equalTo(-40)
        }
        
        webView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(navBarView.snp.bottom).offset(24)
            make.bottom.equalTo(convertnButton.snp.top).offset(-28)
        }
        
        navBarView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIDevice.hasNotch ? 160 : 120)
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
            make.size.equalTo(326)
        }
        
        rateUsPopUp.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(327)
            make.height.equalTo(297)
        }
    }
    
    override func bind() {
        super.bind()
        loadFile()
        
        navBarView.rx.backButtonTapped
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.pop()
            }).disposed(by: disposeBag)
        
        convertnButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }

                if !CacheManager.shared.isFilesRateUsShown {
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
}

// MARK: Private methods

private extension DocumentViewController {
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
        toShow ? CacheManager.shared.filesRateUsPassed() : showLogicFlow()
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
                    self.viewModel.convertToPDF(from: self.webView)
                }
            }
        }
    }
    
    func loadFile() {
        let request = URLRequest(url: viewModel.fileModel.fileURL)
        webView.load(request)
    }
    
}

// MARK: QLPreviewControllerDelegate, QLPreviewControllerDataSource

extension DocumentViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        PDFPreviewItem(data: viewModel.dataRelay.value ?? Data())
    }
}

extension DocumentViewController: AlertDelegate {
    func selectedButtonTapped() {
        viewModel.pop()
        blurView.hide()
    }
    
    func buttonTapped() {
        previewController.dataSource = self
        previewController.delegate = self
        previewController.modalPresentationStyle = .fullScreen
        present(previewController, animated: true, completion: nil)
    }
}
