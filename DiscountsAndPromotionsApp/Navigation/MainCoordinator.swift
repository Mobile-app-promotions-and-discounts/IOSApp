import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var scanCoordinator: ScanFlowCoordinatorProtocol?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = MainTabBarController()
        tabBarController.coordinator = self
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    func startScanFlow() {
        scanCoordinator = ScanFlowCoordinator(navigation: navigationController)
        scanCoordinator?.start()
    }
}
