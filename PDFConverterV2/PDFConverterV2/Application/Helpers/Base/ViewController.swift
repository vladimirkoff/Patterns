
import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
                message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }

    var backgroundColor: UIColor? { return R.color.colors.background()}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor

        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
        setupNavigationItems()
        bind()
    }

    func setupNavigationItems() {}

    func setupStyle() {}

    func arrangeSubviews() {}

    func setupViewConstraints() {}

    func bind() {}

}
