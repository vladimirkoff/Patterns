
import UIKit
import RxSwift
import RxCocoa

protocol AlertDelegate: class {
    func selectedButtonTapped()
    func buttonTapped()
}

final class Alert: View {
    
    weak var delegate: AlertDelegate?
    
    private let image: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitSemiBold(size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = R.color.colors.black()
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitRegular(size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = R.color.colors.grey()
        label.isHidden = true
        return label
    }()
    
    let selectedButton: Button = {
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
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        addSubview(image)
        addSubview(title)
        addSubview(subtitle)
        addSubview(button)
        addSubview(selectedButton)
    }
    
    override func setupStyle() {
        super.setupStyle()
        layer.cornerRadius = 32
        backgroundColor = R.color.colors.white()
        alpha = 0.0
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(title.snp.top).offset(-21)
            make.size.equalTo(120)
        }
        
        subtitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(selectedButton.snp.top).offset(-20)
        }
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(selectedButton.snp.top).offset(-20)
        }
        
        selectedButton.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(34)
            make.bottom.equalTo(button.snp.top).offset(-9)
            make.height.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureNoFilesAlert() {
        selectedButton.isHidden = true
        button.isHidden = true
        
        subtitle.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        
        title.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subtitle.snp.top).offset(-5)
        }
    }
    
    func configure(with type: AlertTypes) {
        image.image = type.image
        title.text = type.title
        subtitle.text = type.subtitle
        subtitle.isHidden = !(type == .sizeExceeded || type == .noFiles)
        guard type != .noFiles else { configureNoFilesAlert(); return }
        selectedButton.setTitle(type.selectedButtonTitle, for: .normal)
        button.setTitle(type.buttonTitle, for: .normal)
        addActions()
        
        guard type == .sizeExceeded else { return }
        title.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subtitle.snp.top).offset(-20)
        }
        
        selectedButton.snp.remakeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(34)
            make.bottom.equalTo(-28)
            make.height.equalTo(48)
        }
    }
    
    private func addActions() {
        selectedButton.addTarget(self, action: #selector(selectedButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func selectedButtonTapped() {
        delegate?.selectedButtonTapped()
    }
    @objc private func buttonTapped() {
        delegate?.buttonTapped()
    }
}
