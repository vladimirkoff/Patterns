
import UIKit
import WebKit
import WeScan

extension PDFBaseViewController: UIScrollViewDelegate, UICollectionViewDelegate {}

class PDFBaseViewController: ViewController {
    
    let blurView: UIVisualEffectView = .createBlur()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: buildLayout())
        collectionView.register(FileCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.delegate = self
        return collectionView
    }()
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 18
        return view
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.tipLabelText()
        label.numberOfLines = 2
        label.backgroundColor = R.color.colors.white()
        label.layer.cornerRadius = 24
        label.textAlignment = .center
        label.clipsToBounds = true
        label.alpha = 0.0
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.images.components.right()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.0
        return iv
    }()
    
    let selectedPlusImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.images.components.plusSelected()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.0
        return iv
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitBold(size: 16)
        label.textColor = R.color.colors.black()
        label.backgroundColor = R.color.colors.white()
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let convertnButton: Button = {
        let btn = Button()
        btn.backgroundColor = R.color.colors.redPale()
        btn.setTitle(R.string.localizable.convert(), for: .normal)
        btn.titleLabel?.font = R.font.outfitBold(size: 16)
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let pdfImage: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.images.application.pdf()
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.0
        return iv
    }()
    
    let convertingLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.outfitSemiBold(size: 24)
        label.textColor = R.color.colors.black()
        label.text = R.string.localizable.converting()
        label.alpha = 0.0
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.alpha = 0.0
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 6
        progressView.subviews[1].clipsToBounds = true
        progressView.progressTintColor = R.color.colors.red()
        return progressView
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.0
        label.font = R.font.outfitSemiBold(size: 24)
        label.textColor = R.color.colors.black()
        return label
    }()
    
    var alert = Alert()
    
    lazy var processingViews = [pdfImage, convertingLabel, progressView, percentLabel]
    lazy var pdfViews = [webView, convertnButton, collectionView, counterLabel]
    lazy var hidableTipViews = [blurView, tipLabel, arrowImageView, selectedPlusImageView]
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.navigationBar.isHidden = true
    }
    
    func showProcessing(toShow: Bool) {
        toShow ? pdfViews.hide() : pdfViews.show()
        toShow ? processingViews.show() : processingViews.hide()
    }
    
    func showAlert(toShow: Bool) {
        toShow ? blurView.show() : blurView.hide()
        toShow ? alert.show() : alert.hide()
    }
}

private extension PDFBaseViewController {
    func buildLayout() -> SnappingCollectionViewLayout {
        let layout = SnappingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: view.bounds.width - 48, height: view.bounds.height / 1.87)
        return layout
    }
}
