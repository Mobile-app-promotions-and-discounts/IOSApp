import SnapKit
import UIKit

final class ModalReviewViewController: UIViewController {
    weak var coordinator: ProductCardEnabledCoordinatorProtocol?
    private var viewModel: ProductCardViewModel

    private let insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

//    private lazy var reviewView = ProductReviewView()

    private lazy var reviewButton = {
        let button = PrimaryButton(type: .custom)
        button.setTitle(NSLocalizedString("NewReview", tableName: "ProductFlow", comment: ""), for: .normal)
        return button
    }()

    private lazy var handle = {
        let handle = UIView()
        handle.backgroundColor = .cherryWhite
        handle.layer.cornerRadius = 2.5
        return handle
    }()

    private lazy var mainView = {
        let mainView = UIView()
        mainView.backgroundColor = .cherryWhite
        mainView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return mainView
    }()

    init(viewModel: ProductCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .clear

//        setupViews()
    }

//    private func setupViews() {
//        view.addSubview(handle)
//        handle.snp.makeConstraints { make in
//            make.width.equalTo(60)
//            make.height.equalTo(5)
//            make.centerX.top.equalToSuperview()
//        }
//
//        view.addSubview(mainView)
//        mainView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.top.equalTo(handle.snp.bottom).offset(4)
//        }
//
//        mainView.addSubview(reviewView)
//        reviewView.backgroundColor = .clear
//        reviewView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//        }
//        viewModel.setupProductReviewView(reviewView)
//        viewModel.configureReviewView(reviewView)
//
//        mainView.addSubview(reviewButton)
//        reviewButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(insets)
//            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
//            make.height.equalTo(51)
//        }
//    }
}
