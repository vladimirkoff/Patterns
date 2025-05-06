
import UIKit
import SnapKit

final class DocumentCell: CollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.colors.white()
        return view
    }()
    
    private let documentName: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitSemiBold(size: 12)
        label.textColor = R.color.colors.black()
        label.textAlignment = .left
        return label
    }()
    
    private let documentDate: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitRegular(size: 12)
        label.textColor = R.color.colors.grey()
        label.textAlignment = .left
        return label
    }()
    
    private let dotsButton: MenuButton = {
        let button = MenuButton(forCollectionView: true)
        button.setImage(R.image.images.application.more(), for: .normal)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override func setupStyle() {
        super.setupStyle()
        clipsToBounds = true
        layer.cornerRadius = 18
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        addSubview(imageView)
        addSubview(bottomBackgroundView)
        bottomBackgroundView.addSubview(documentName)
        bottomBackgroundView.addSubview(documentDate)
        bottomBackgroundView.addSubview(dotsButton)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
       
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(156)
        }
        
        bottomBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
        
        documentName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(100)
        }
        
        documentDate.snp.makeConstraints { make in
            make.top.equalTo(documentName.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        dotsButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func configure(document: Document, showBackgroundClosure: @escaping(BoolClosure), hideBackgroundClosure: @escaping(BoolClosure)) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        documentName.text = document.name
        documentDate.text = dateFormatter.string(from: document.date)
        imageView.image = UIImage(data: document.imageCoverData)
        dotsButton.showBackgroundClosure = showBackgroundClosure
        dotsButton.hideBackgroundClosure = hideBackgroundClosure
    }
    
    func setMenu(menu: UIMenu) {
        dotsButton.menu = menu
    }
}

