import UIKit

final class ProfileScreenCoordinator: Coordinator {

    private let userNetworkService: UserNetworkServiceProtocol
    private let authService: AuthServiceProtocol
    weak var mainCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController,
         userNetworkService: UserNetworkServiceProtocol,
         authService: AuthServiceProtocol) {
        self.navigationController = navigationController
        self.userNetworkService = userNetworkService
        self.authService = authService
    }

    func start() {
        let profileViewModel = ProfileViewModel(userNetworkService: userNetworkService,
                                                authService: authService)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.coordinator = self
        navigationController.pushViewController(profileViewController, animated: false)
    }

    func exit(hideNavBar: Bool) {
        self.navigationController.navigationBar.isHidden = hideNavBar
        navigationController.popViewController(animated: true)
    }

    func navigateToEditProfileScreen() {
        let viewModel = EditProfileViewModel(userNetworkService: userNetworkService)
        let editProfileViewController = EditProfileViewController(viewModel: viewModel)
        editProfileViewController.coordinator = self
        editProfileViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(editProfileViewController, animated: true)
    }

    func navigateToRegionScreen() {
        let profileViewModel = ProfileViewModel(userNetworkService: userNetworkService,
                                                authService: authService)
        let regionViewController = RegionViewController(viewModel: profileViewModel)
        regionViewController.coordinator = self
        navigationController.pushViewController(regionViewController, animated: true)
    }

    func navigateToChooseRegionScreen() {
        let chooseRegionViewController = ChooseRegionViewController()
        chooseRegionViewController.coordinator = self
        navigationController.pushViewController(chooseRegionViewController, animated: true)
    }

    func navigateToReviewsScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Reviews", message: "⭐️⭐️⭐️⭐️⭐️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToNotificationsScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Notifications", message: "📳", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToSupportScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Support", message: "💬", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToAboutAppScreen() {
        // Заглушка до реализации функционала
        let viewModel = AboutAppViewModel()
        let vc = AboutAppViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func navigateToExitAccountScreen() {
        mainCoordinator?.navigateToAuthScreen()
    }

    func navigateBack() {
        navigationController.popViewController(animated: true)
    }

    func navigateToWebView(to webView: WebViewURL) {
        let webViewVC = WebViewViewController(webViewURL: webView) { [weak self] in
            self?.navigateBack()
        }
        navigationController.pushViewController(webViewVC, animated: true)
    }
}
