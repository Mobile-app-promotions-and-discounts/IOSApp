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
        self.navigationController.navigationBar.isHidden = true
    }
    
    func start() { }
    
    func navigateLoginViewController(from viewController: UIViewController) {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.viewControllers = [loginViewController]
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = viewController as? any UIViewControllerTransitioningDelegate
        viewController.present(navigationController, animated: true)
    }
    
    func navigateToRegistrationScreen() {
        let registrationViewModel = RegistrationViewModel(userNetworkService: userNetworkService,
                                                          authService: authService)
        let registerViewController = RegistrationViewController(viewModel: registrationViewModel)
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    func navigateToSuccessScreen() {
        let sucessViewController = SuccessRegistrationViewController()
        sucessViewController.coordinator = self
        sucessViewController.modalPresentationStyle = .custom
        navigationController.pushViewController(sucessViewController, animated: true)
    }
    
    func backToNavigateLoginViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func navigateToGeopositionScreen() {
        //TODO: - в следующем спринте
    }
    
    func navigateToMainScreen() {
        mainCoordinator?.navigateToMainScreen()
    }
    
}
