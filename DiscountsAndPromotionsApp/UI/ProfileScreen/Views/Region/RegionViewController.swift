import UIKit
import Combine

final class RegionViewController: UIViewController {
    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private let viewModel: ProfileViewModelProtocol

    private var location: String? {
        didSet {
            NotificationCenter.default.post(
                name: Notification.Name("updateLocation"),
                object: location
            )
            self.regionButton.setTitle(location, for: .normal)
            UserDefaults.standard.setValue(location, forKey: "storedLocation")
        }
    }

    private var locationKey = "locationEnabled"

    private var manualLocation = Set<AnyCancellable>()

    // MARK: - Layout elements
    private lazy var backButton = UIBarButtonItem(
        image: UIImage(named: "ic_back")?.withTintColor(.cherryBlack).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    private lazy var titleLabel = UIBarButtonItem(
        title: NSLocalizedString("Region", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: nil
    )

    private lazy var regionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cherryLightBlue
        button.setImage(.buttonRegionGreen, for: .normal)
        let text = UserDefaults.standard.string(forKey: locationKey) ??
        NSLocalizedString("Unknown", tableName: "ProfileFlow", comment: "")
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: #selector(regionDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var locationLabel: TextField = {
        let locationLabel = TextField()
        locationLabel.backgroundColor = .cherryLightBlue
        locationLabel.text = NSLocalizedString("Geolocation", tableName: "ProfileFlow", comment: "")
        locationLabel.font = CherryFonts.headerMedium
        locationLabel.textColor = .cherryBlack
        locationLabel.isUserInteractionEnabled = false
        return locationLabel
    }()

    private lazy var locationSwitch: UISwitch = {
        let locationSwitch = UISwitch()
        locationSwitch.isOn = false
        locationSwitch.addTarget(self, action: #selector(locationDidSwitch), for: .valueChanged)
        return locationSwitch
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cherryWhite
        setupNavBar()
        addRegionButton()
        addLocationControls()

        let locationAllowed = UserDefaults.standard.bool(forKey: locationKey)
        locationSwitch.isOn = locationAllowed
        if let location = UserDefaults.standard.string(forKey: "storedLocation") {
        }

        NotificationCenter.default
            .publisher(for: Notification.Name("manualLocation"))
            .sink { object in
                self.location = object.object as? String
                self.locationSwitch.isOn = false
                UserDefaults.standard.set(false, forKey: self.locationKey)
            }
            .store(in: &manualLocation)

    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItems = [backButton, titleLabel]

        let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.cherryBlack,
            NSAttributedString.Key.font: CherryFonts.headerLarge as Any]
        titleLabel.setTitleTextAttributes(titleAttributes, for: .normal)
    }

    @objc
    private func regionDidTap() {
        coordinator?.navigateToChooseRegionScreen()
    }

    @objc
    private func locationDidSwitch() {
        UserDefaults.standard.set(locationSwitch.isOn, forKey: locationKey)
    }

    @objc
    private func didTapBackButton() {
        self.coordinator?.exit(hideNavBar: true)
    }

    // MARK: - Layout methods
    private func addRegionButton() {
        view.addSubview(regionButton)
        regionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.leading.trailing.equalTo(self.view).inset(16)

        }
    }

    private func addLocationControls() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(regionButton.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(regionButton)
        }
        view.addSubview(locationSwitch)
        locationSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(locationLabel).inset(12)
            make.centerY.equalTo(locationLabel)
        }
    }
}
