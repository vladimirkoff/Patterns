
import UIKit
import RxSwift

final class SettingsViewController: ViewController {
    
    private let viewModel: SettingsViewModel
    
    private let navBarView: NavBarView = {
        let view = NavBarView()
        view.configure(screenType: .settings)
        return view
    }()
    
    private let feedbackButton = SettingButton(title: R.string.localizable.settingsScreenFeedback(), image: R.image.images.settings.feedback(), tag: 0)
    private let rateUsButton = SettingButton(title: R.string.localizable.settingsScreenRateUs(), image: R.image.images.settings.rate(), tag: 1)
    private let shareButton = SettingButton(title: R.string.localizable.settingsScreenShare(), image: R.image.images.settings.share(), tag: 2)
    private let privacyPolicyButton = SettingButton(title: R.string.localizable.settingsScreenPrivacyPolicy(), image: R.image.images.settings.privacy(), tag: 3)
    private let termsOfButton = SettingButton(title: R.string.localizable.settingsScreenTermsOfService(), image: R.image.images.settings.terms(), tag: 4)
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = R.color.colors.background()
        stackView.layer.cornerRadius = 24
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var mergedObservable = Observable.merge(tapObservables)
    
    private lazy var tapObservables = settingsButtons.map { button in
        button.rx.tap.map { button }
    }
    
    private lazy var settingsButtons = [feedbackButton, rateUsButton, shareButton, privacyPolicyButton, termsOfButton]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupStyle() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func bind() {
        super.bind()
        
        navBarView.rx.backButtonTapped
            .drive(onNext: { [weak self] _ in
                self?.viewModel.goBack()
            })
            .disposed(by: disposeBag)
        
        mergedObservable
            .subscribe(onNext: { [weak self] button in
                self?.viewModel.transition(for: button.tag)
            })
            .disposed(by: disposeBag)
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        view.addSubview(navBarView)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(feedbackButton)
        buttonsStackView.addArrangedSubview(rateUsButton)
        buttonsStackView.addArrangedSubview(shareButton)
        buttonsStackView.addArrangedSubview(privacyPolicyButton)
        buttonsStackView.addArrangedSubview(termsOfButton)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        navBarView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIDevice.hasNotch ? 140 : 120)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(navBarView.snp.bottom).offset(24)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.centerX.equalToSuperview()
        }
    }
}
