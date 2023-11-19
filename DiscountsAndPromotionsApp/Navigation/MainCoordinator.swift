import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: navigationController)
        childCoordinators.append(mainScreenCoordinator)

        let tabBarController = MainTabBarController()
        tabBarController.mainScreenCoordinator = mainScreenCoordinator
        tabBarController.setUpViewControllers()
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
