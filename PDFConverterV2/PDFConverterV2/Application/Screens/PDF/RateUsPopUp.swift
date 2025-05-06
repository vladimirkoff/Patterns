
import UIKit
import RxSwift
import RxCocoa

final class RateUsPopUp: View {
    
    fileprivate var currentState: State
    
    enum State {
        case rate
        case thankYou
        
        var title: String {
            switch self {
            case .rate:
                "Do you like the app?"
            case .thankYou:
                "Thank you for your feedback!"
            }
        }
        
        var subTitle: String {
            switch self {
            case .rate:
                "Feel free to rate us based on\nservice you get from the app"
            case .thankYou:
                "Feel free to say “Thank you!”\nif you like the application"
            }
        }
                
        var buttonTitle: String {
            switch self {
            case .rate:
                "Not now"
            case .thankYou:
                "Cancel"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .rate:
                R.image.images.rateUs.rate()
            case .thankYou:
                R.image.images.rateUs.thankYou()
            }
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.colors.black()
        label.font = R.font.outfitSemiBold(size: 20)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = R.font.outfitRegular(size: 16)
        label.textColor = R.color.colors.grey()
        return label
    }()
    
    fileprivate let selectedButton: Button = {
        let btn = Button()
        btn.backgroundColor = R.color.colors.redPale()
        btn.layer.cornerRadius = 20
        btn.titleLabel?.font = R.font.outfitBold(size: 16)
        return btn
    }()
    
    fileprivate let button: Button = {
        let btn = Button()
        btn.layer.cornerRadius = 12
        btn.setTitleColor(R.color.colors.black(), for: .normal)
        btn.titleLabel?.font = R.font.outfitBold(size: 16)
        return btn
    }()
    
    init(state: State) {
        currentState = state
        super.init(frame: .zero)
        configure(state: state)
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        layer.cornerRadius = 32
        backgroundColor = R.color.colors.white()
        alpha = 0.0
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(selectedButton)
        addSubview(button)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-20)
        }
        
        selectedButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(button.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(34)
            $0.height.equalTo(48)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(selectedButton.snp.top).offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-8)
            $0.top.equalTo(80)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-20)
        }
    }
    
    func configure(state: State) {
        currentState = state
        imageView.image = state.image
        titleLabel.text = state.title
        subtitleLabel.text = state.subTitle
        selectedButton.setTitle("Submit", for: .normal)
        button.setTitle(state.buttonTitle, for: .normal)
    }
}

// MARK: Reactive

extension Reactive where Base == RateUsPopUp {
    var submitButtonTapped: Driver<RateUsPopUp.State> {
        base.selectedButton.rx.tap.asDriver().compactMap { base.currentState }
    }

    var notNowButtonTapped: Driver<Void> {
        base.button.rx.tap.asDriver(onErrorDriveWith: .never())
    }
}
