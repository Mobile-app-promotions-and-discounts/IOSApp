import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let scanDummy = ScanDummyViewController()

        let mainTabBarController = MainTabBarController()
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: UINavigationController())
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: UINavigationController())
        let profileScreenCoordinator = ProfileScreenCoordinator(navigationController: UINavigationController())
        let scanCoordinator = ScanFlowCoordinator(navigationController: UINavigationController(rootViewController: scanDummy))

        mainScreenCoordinator.start()
        favoritesScreenCoordinator.start()
        profileScreenCoordinator.start()
        scanCoordinator.start()

        scanDummy.coordinator = scanCoordinator

        childCoordinators.append(mainScreenCoordinator)
        childCoordinators.append(favoritesScreenCoordinator)
        childCoordinators.append(profileScreenCoordinator)
        childCoordinators.append(scanCoordinator)

        mainTabBarController.viewControllers = [mainScreenCoordinator.navigationController,
                                                favoritesScreenCoordinator.navigationController,
                                                profileScreenCoordinator.navigationController,
                                                scanCoordinator.navigationController]
        mainTabBarController.setUpTabBarItems()

        navigationController.viewControllers = [mainTabBarController]
    }
}
