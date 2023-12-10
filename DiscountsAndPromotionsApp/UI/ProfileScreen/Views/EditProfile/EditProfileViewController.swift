import UIKit
import AVFoundation
import Combine

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private let viewModel: ProfileViewModelProtocol

    var avatarUpdated = Set<AnyCancellable>()

    // MARK: - Layout elements
    private lazy var cancelButton = UIBarButtonItem(
        title: NSLocalizedString("Cancel", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: #selector(didTapCancelButton))

    private lazy var doneButton = UIBarButtonItem(
        title: NSLocalizedString("Done", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: #selector(didTapDoneButton))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        guard let profile = viewModel.profile else { return }
        self.view = EditProfileView(frame: .zero, viewController: self, profile: profile)

        NotificationCenter.default
            .publisher(for: Notification.Name("updateAvatar"))
            .sink { object in
                let view = self.view as? EditProfileView
                let image = object.object as? UIImage
                view?.setAvatarImage(image: image)
            }
            .store(in: &avatarUpdated)
    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func changeAvatarDidTap() {
        present(ChangeAvatarViewController(), animated: true)
    }

    // MARK: - Private Methods
    @objc
    private func didTapCancelButton() {
        self.coordinator?.exit(hideNavBar: true)
    }

    @objc
    private func didTapDoneButton() {
        let view = self.view as? EditProfileView
        guard let profile = view?.collectFieldsToProfile() else { return }

        NotificationCenter.default.post(
            name: Notification.Name("updateProfile"),
            object: profile
        )

        self.coordinator?.exit(hideNavBar: true)
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        // Предлагаю обсудить с дизайнерами использование кастомного стиля, по-моему Apple такое не поощряет
        let navbarAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.cherryBlue,
            NSAttributedString.Key.font: CherryFonts.textLarge as Any]
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.setTitleTextAttributes(navbarAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(navbarAttributes, for: .highlighted)
        navigationItem.rightBarButtonItem = doneButton
        doneButton.setTitleTextAttributes(navbarAttributes, for: .normal)
        doneButton.setTitleTextAttributes(navbarAttributes, for: .highlighted)
    }
}
