import UIKit
import Combine

final class ProfileViewController: UIViewController {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var profileView: ProfileView?
    private var viewModel: ProfileViewModelProtocol

    private var profileSubscriber: AnyCancellable?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
        self.navigationController?.navigationBar.isHidden = true
    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.profileView = ProfileView(frame: .zero, viewModel: self.viewModel, viewController: self)
        bind()

        viewModel.getProfileData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func editDidTap() {
        coordinator?.navigateToEditProfileScreen()
    }

    func regionDidTap() {
        coordinator?.navigateToRegionScreen()
    }

    func reviewsDidTap() {
        coordinator?.navigateToReviewsScreen()
    }

    func notificationsDidTap() {
        coordinator?.navigateToNotificationsScreen()
    }

    func supportDidTap() {
        coordinator?.navigateToSupportScreen()
    }

    func deleteAccountDidTap() {
        coordinator?.navigateToDeleteAccountScreen()
    }

    func exitAccountDidTap() {
        coordinator?.navigateToExitAccountScreen()
    }

    // MARK: - Private methods
    private func bind() {
        profileSubscriber = viewModel.profilePublisher.sink(
            receiveValue: { profile in
                guard let profile = profile else { return }
                self.profileView?.updateViews(
                    avatar: profile.avatar,
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    phone: profile.phone
                )
            }
        )
    }
}
