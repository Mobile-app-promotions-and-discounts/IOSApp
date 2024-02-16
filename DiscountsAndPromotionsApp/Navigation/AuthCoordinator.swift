import UIKit

final class AuthCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()
    weak var mainCoordinator: MainCoordinator?

    private let authService: AuthServiceProtocol
    private let userNetworkService: UserNetworkServiceProtocol

    init(authService: AuthServiceProtocol,
         userNetworkService: UserNetworkServiceProtocol) {

        self.authService = authService
        self.userNetworkService = userNetworkService
        setupNavigationController()
    }

    func start() { }

    func navigateLoginViewController(from viewController: UIViewController) {
        /*
         Временное решение
         */
        navigateToGeopositionScreen(from: viewController)

        /*
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.viewControllers = [loginViewController]
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = viewController as? any UIViewControllerTransitioningDelegate
        viewController.present(navigationController, animated: true)
         */
    }

    func navigateToRegistrationScreen() {
        let registrationViewModel = RegistrationViewModel(userNetworkService: userNetworkService,
                                                          authService: authService)
        let registerViewController = RegistrationViewController(viewModel: registrationViewModel)
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }

    func navigateToPrivacyWebView(from viewController: UIViewController) {
        let privacyWebViewVC = WebViewViewController(titleName: L10n.WebView.termsAndPrivacy,
                                                     webViewURL: .termsAndPrivacy)
        privacyWebViewVC.modalPresentationStyle = .overFullScreen
        viewController.present(privacyWebViewVC, animated: true)
    }

    func navigateToSuccessScreen() {
        let sucessViewController = SuccessRegistrationViewController()
        sucessViewController.coordinator = self
        navigationController.pushViewController(sucessViewController, animated: true)
    }

    func navigateToRecoveryStartScreen() {
        let recoveryStartViewModel = RecoveryStartViewModel()
        let recoveryStartViewController = RecoveryStartViewController(viewModel: recoveryStartViewModel)
        recoveryStartViewController.coordinator = self
        navigationController.pushViewController(recoveryStartViewController, animated: true)
    }

    func navigateToRecoveryEndScreen() {
        let recoveryEndViewModel = RecoveryEndViewModel()
        let recoveryEndViewController = RecoveryEndViewController(viewModel: recoveryEndViewModel)
        recoveryEndViewController.coordinator = self
        navigationController.pushViewController(recoveryEndViewController, animated: true)
    }

    func popToNavigate() {
        navigationController.popViewController(animated: true)
    }

    func navigateToGeopositionScreen(from viewController: UIViewController) {
        let navController = GenericNavigationController()
        let selectionCityViewModel = SelectionCityViewModel(authService: authService)
        let selectionCityVC = SelectionCityViewController(viewModel: selectionCityViewModel)
        navController.viewControllers = [selectionCityVC]
        navController.modalPresentationStyle = .overFullScreen
        viewController.present(navController, animated: true)
    }

    func navigateToMainScreen() {
        mainCoordinator?.navigateToMainScreen()
    }

    private func setupNavigationController() {
        navigationController.navigationBar.isHidden = true
        navigationController.view.layer.cornerRadius =  12
        navigationController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

}
