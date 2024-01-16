import Combine
import SnapKit
import UIKit

final class SplashViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    private let authService: AuthServiceProtocol
    private var isUserAuthorized: CurrentValueSubject<Bool?, Never>
    private var isViewAppear: CurrentValueSubject<Bool, Never>
    
    var validToSubmit: AnyPublisher<Bool?, Never> {
        return Publishers.CombineLatest(isUserAuthorized, isViewAppear)
            .receive(on: DispatchQueue.main)
            .map { isUserAuthorized, isViewAppear in
                guard let isUserAuthorized else { return nil }
                return isUserAuthorized && isViewAppear
            } .eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()

    private let cherryImageView: UIImageView = {
        let imageView = UIImageView(image: .cherryLogo)
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Черри", tableName: "LaunchFlow", comment: "")
        label.font = CherryFonts.logoText
        label.textColor = .cherryRedGreetings
        label.textAlignment = .left
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Акции и скидки каждый день", tableName: "LaunchFlow", comment: "")
        label.font = CherryFonts.textLarge
        label.numberOfLines = 2
        label.textColor = .cherryRedGreetings
        label.textAlignment = .center
        return label
    }()

    init(authService: AuthServiceProtocol) {
        self.authService = authService
        self.isUserAuthorized = CurrentValueSubject(nil)
        self.isViewAppear = CurrentValueSubject(false)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkUserAuthorization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppear.send(true)
        bindingOn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bindingOff()
    }

    private func checkUserAuthorization() {
        authService.verifyToken()
    }

    private func selectUserFlow(_ isAutorizated: Bool) {
        if isAutorizated {
            coordinator?.navigateToMainScreen()
        } else {
            coordinator?.navigateToAuthScreen()
        }
    }

    private func bindingOn() {
        authService.isTokenValidUpdate
            .sink { isValid in
                self.isUserAuthorized.send(isValid)
            }
            .store(in: &cancellables)
        validToSubmit
            .sink { [weak self] isAutorizated in
                guard let isAutorizated else { return }
                self?.selectUserFlow(isAutorizated)
            }
            .store(in: &cancellables)
    }
    
    private func bindingOff() {
        cancellables.removeAll()
    }

    private func setupViews() {
        view.backgroundColor = .cherryWhite
        [cherryImageView, nameLabel, taglineLabel].forEach { view.addSubview($0) }

        cherryImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(180)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(cherryImageView.snp.leading)
            make.top.equalTo(cherryImageView.snp.bottom).inset(-42)
        }

        taglineLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(79)
            make.top.equalTo(nameLabel.snp.bottom).inset(-12)
        }
    }
}
