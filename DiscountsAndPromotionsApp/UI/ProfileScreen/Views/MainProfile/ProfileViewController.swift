import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: ProfileScreenCoordinator?

    private var profileView: ProfileView?
    private var viewModel: ProfileViewModelProtocol

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
        viewModel.onChange = { [weak self] in
            guard let profile = self?.viewModel.profile else { return }
            self?.profileView?.updateViews(
                avatar: profile.avatar,
                firstName: profile.firstName,
                lastName: profile.lastName,
                phone: profile.phone
            )
        }

        viewModel.onError = { [weak self] in
            guard let error = self?.viewModel.error else { return }
            print(error.localizedDescription)
        }
    }

}
