
import UIKit
import SnapKit

final class SettingButton: Button {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let titleButtonLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitMedium(size: 16)
        label.textColor = R.color.colors.black()
        label.textAlignment = .left
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.images.settings.chevronRight()
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    init(title: String, image: UIImage?, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        titleButtonLabel.text = title
        logoImageView.image = image
        layoutElements()
        
        backgroundColor = R.color.colors.white()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutElements() {
        addSubview(logoImageView)
        addSubview(titleButtonLabel)
        addSubview(chevronImageView)
        
        snp.makeConstraints { make in
            make.height.equalTo(snp.width).multipliedBy(58.0 / 327.0)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        titleButtonLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(16)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
