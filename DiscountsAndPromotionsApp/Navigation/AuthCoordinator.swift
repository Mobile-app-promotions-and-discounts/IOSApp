import UIKit

final class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()
    
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
        loginViewController.modalPresentationStyle = .custom
        loginViewController.transitioningDelegate = viewController as? any UIViewControllerTransitioningDelegate
        viewController.present(loginViewController, animated: true)
    }
    
    func navigateToRegistrationScreen(from viewController: UIViewController) {
        let registerViewController = RegistrationViewController()
        registerViewController.coordinator = self
        registerViewController.modalPresentationStyle = .custom
        registerViewController.transitioningDelegate = viewController as? any UIViewControllerTransitioningDelegate
        viewController.present(registerViewController, animated: true)
    }
    
    func navigateToSuccessScreen(from viewController: UIViewController) {
        let registerViewController = SuccessRegistrationViewController()
        registerViewController.coordinator = self
        registerViewController.modalPresentationStyle = .custom
        registerViewController.transitioningDelegate = viewController as? any UIViewControllerTransitioningDelegate
        viewController.present(registerViewController, animated: true)
    }
    
    func navigateTogeopositionScreen() {
        //TODO: - в следующем спринте
    }
    
}
