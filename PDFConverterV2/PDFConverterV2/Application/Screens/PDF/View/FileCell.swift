
import UIKit
import SnapKit

final class FileCell: CollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupStyle() {
        super.setupStyle()
        isUserInteractionEnabled = false
        clipsToBounds = true
        layer.cornerRadius = 18
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        addSubview(imageView)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
