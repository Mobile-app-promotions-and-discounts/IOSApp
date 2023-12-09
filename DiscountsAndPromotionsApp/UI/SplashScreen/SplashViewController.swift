import UIKit
import SnapKit

final class SplashViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private let tokenStorage: AuthTokenStorageProtocol

    private var isUserAuthorized = false

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .launchScreenBackground
        return imageView
    }()

    private lazy var cherryLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .cherryLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cherryDescriptionLabel: UILabel = {
        let label = StrokeLabel()
        label.text = L10n.LaunchScreen.cherryDescription
        label.font = CherryFonts.titleExtraLarge
        label.textColor = .cherryWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        label.strokeSize = 2
        label.strokeColor = .cherryBlack
        return label
    }()

    init(tokenStorage: AuthTokenStorageProtocol = AuthTokenKeychainStorage.shared) {
        self.tokenStorage = tokenStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserAuthorization()
        selectUserFlow()
    }

    private func checkUserAuthorization() {
        isUserAuthorized = tokenStorage.token != nil ? true : false
    }

    private func selectUserFlow() {
        isUserAuthorized ? coordinator?.navigateToMainScreen() : coordinator?.navigateToAuthScreen(from: self)
    }

    private func setupConstraints() {
        [backgroundImageView, cherryLogoImageView, cherryDescriptionLabel].forEach { view.addSubview($0) }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cherryLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIScreen.main.bounds.height / 3.2)
        }

        cherryDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cherryLogoImageView.snp.bottom).offset(12)
            make.width.equalTo(217)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension SplashViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PartialSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class PartialSizePresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height / 4.3, width: bounds.width, height: bounds.height / 1.3)
    }
}
