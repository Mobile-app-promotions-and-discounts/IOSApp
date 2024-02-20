import Combine
import CoreLocation
import UIKit

final class SuccessRegistrationViewController: AuthParentViewController {

    let geopositionService = GeoposiotionService.shared
    private var cancellables = Set<AnyCancellable>()

    private lazy var cherryImageView: UIImageView = {
        let image = UIImage(named: "cherryHi") ?? UIImage()
        return UIImageView(image: image)
    }()

    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Location.welcome
        label.font = CherryFonts.titleExtraLarge
        label.textColor = .cherryBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var enterCityLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Location.enterCity
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    private lazy var automaticButton: UIButton = {
        let button = PrimaryButton()
        button.setTitle(L10n.Location.automatical, for: .normal)
        button.addTarget(self, action: #selector(automaticLocationAction), for: .touchUpInside)
        return button
    }()

    private lazy var manualButton: UIButton = {
        let button = SecondaryButton()
        button.setTitle(L10n.Location.manual, for: .normal)
        button.addTarget(self, action: #selector(manuallyLocationAction), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [automaticButton, manualButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    @objc private func automaticLocationAction() {
        geopositionService.requestLocationAuthorization()

        geopositionService.geopositionStatus
            .receive(on: RunLoop.current)
            .sink { [weak self] geopositionStatus in
                self?.checkGeopositionStatus(geopositionStatus)
            }.store(in: &cancellables)

    }

    @objc private func manuallyLocationAction() {
        coordinator?.navigateToGeopositionScreen(from: self)
    }

    private func checkGeopositionStatus(_ status: GeopositionStatus?) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            showError()
        case .authorizedWhenInUse:
            navigateToMainScreen()
        case nil:
            break
        }
    }

    private func navigateToMainScreen() {
        self.dismiss(animated: true)
        coordinator?.navigateToMainScreen()
    }

    private func showError() {
        ErrorHandler.handle(error: AppError.locationSettingError) { [weak self] in
            self?.manuallyLocationAction()
        }
    }

    private func setupConstraints() {
        [cherryImageView,
         welcomeLabel,
         enterCityLabel,
         buttonsStackView].forEach { view.addSubview($0) }

        cherryImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
                .offset(Const.ImageView.topOffset)
        }

        welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cherryImageView.snp.bottom)
                .offset(Const.Welcome.topOffset)
        }

        enterCityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview()
                .inset(Const.EntryCity.horizontalInset)
            $0.top.equalTo(welcomeLabel.snp.bottom)
                .offset(Const.EntryCity.topOffset)
        }

        buttonsStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
                .inset(Const.ButtonStack.horizontalInset)
            $0.bottom.equalToSuperview()
                .inset(Const.ButtonStack.bottomInset)
            $0.height.equalTo(Const.ButtonStack.height)
        }
    }

    private enum Const {
        enum ImageView {
            static let topOffset: CGFloat = 17
        }
        enum Welcome {
            static let topOffset: CGFloat = 25
        }
        enum EntryCity {
            static let topOffset: CGFloat = 20
            static let horizontalInset: CGFloat = 42
        }
        enum ButtonStack {
            static let spacing: CGFloat = 4
            static let horizontalInset: CGFloat = 16
            static let bottomInset: CGFloat = 24
            static let height: CGFloat = 106
        }
    }
}