
import UIKit
import RxSwift
import RxCocoa
import RxSwift
import RxCocoa

final class NavBarView: View {
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI
    
    fileprivate let rightBarButton = Button()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitBold(size: 28)
        label.textColor = R.color.colors.black()
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitRegular(size: 16)
        label.textColor = R.color.colors.grey()
        label.text = R.string.localizable.applicationScreenSubTitle()
        return label
    }()
    
    fileprivate let backButton: Button = {
        let btn = Button()
        btn.setImage(R.image.images.components.back(), for: .normal)
        return btn
    }()
    
    // MARK: Helpers
    
    override func setupStyle() {
        super.setupStyle()
        layer.cornerRadius = 32
        backgroundColor = R.color.colors.white()
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        addSubview(subTitle)
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(rightBarButton)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalTo(24)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        rightBarButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.trailing.equalTo(-24)
            make.centerY.equalTo(backButton.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.bottom.equalTo(subTitle.snp.top).offset(-1)
        }
        
        subTitle.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.bottom.equalTo(-24)
        }
    }
    
    // MARK: External methods
    
    func hideRightBarButton() {
        rightBarButton.isHidden = true
    }
    
    func configure(screenType: NavBarEnum) {
        
        backButton.isHidden = !screenType.hasLeftButton
        subTitle.isHidden = screenType.hasLeftButton
        titleLabel.text = screenType.title
        
        rightBarButton.isHidden = screenType.hasRightButton
        rightBarButton.setImage(screenType.rightButtonImage, for: .normal)
        
        guard screenType != .main else { return }
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(UIDevice.hasNotch ? 77 : 50)
        }
    }
}

extension Reactive where Base == NavBarView {
    var backButtonTapped: Driver<Void> {
        base.backButton.rx.tap.asDriver(onErrorDriveWith: .never())
    }
    
    var rightBarButtonTapped: Driver<Void> {
        base.rightBarButton.rx.tap.asDriver(onErrorDriveWith: .never())
    }
}
