
import UIKit
import SnapKit

final class LaunchViewController: ViewController {
    
    private let viewModel: LaunchViewModel
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.images.icon()
        return imageView
    }()
        
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.viewModel.showApplication()
        }
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        view.addSubview(logoImageView)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(106)
        }
    }
}
