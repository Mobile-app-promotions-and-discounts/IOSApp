import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let mainTabBarController = MainTabBarController()

        let mainScreenCoordinator = MainScreenCoordinator(navigationController: GenericNavigationController())
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: GenericNavigationController())
        let profileScreenCoordinator = ProfileScreenCoordinator(navigationController: GenericNavigationController())

        let scanCoordinator = ScanFlowCoordinator(navigationController: navigationController)
        mainScreenCoordinator.scanCoordinator = scanCoordinator
        favoritesScreenCoordinator.scanCoordinator = scanCoordinator

        mainScreenCoordinator.start()
        favoritesScreenCoordinator.start()
        profileScreenCoordinator.start()

        childCoordinators.append(mainScreenCoordinator)
        childCoordinators.append(favoritesScreenCoordinator)
        childCoordinators.append(profileScreenCoordinator)

        mainTabBarController.viewControllers = [mainScreenCoordinator.navigationController,
                                                favoritesScreenCoordinator.navigationController,
                                                profileScreenCoordinator.navigationController]
        mainTabBarController.setUpTabBarItems()

        navigationController.viewControllers = [mainTabBarController]
    }
}
