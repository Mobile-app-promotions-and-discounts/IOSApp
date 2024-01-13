import Combine
import SnapKit
import UIKit

final class SplashViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    private let authService: AuthServiceProtocol
    private var isUserAuthorized = false
    private var cancellables = Set<AnyCancellable>()

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

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)

        bindTokenStatus()
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
        authService.verifyToken()
    }

    private func selectUserFlow() {
//        временно чтобы убрать экран авторизации
//        coordinator?.navigateToMainScreen()
            coordinator?.navigateToAuthScreen()
//       isUserAuthorized ? coordinator?.navigateToMainScreen() : coordinator?.navigateToAuthScreen()
    }

    private func bindTokenStatus() {
        authService.isTokenValidUpdate
            .sink { isValid in
                self.isUserAuthorized = isValid
            }
            .store(in: &cancellables)
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
