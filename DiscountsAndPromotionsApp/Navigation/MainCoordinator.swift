import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let scanDummy = ScanDummyViewController() // Временно, пока некуда сканер запихнуть

        let mainTabBarController = MainTabBarController()
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: UINavigationController())
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: UINavigationController())
        let profileScreenCoordinator = ProfileScreenCoordinator(navigationController: UINavigationController())
        let scanCoordinator = ScanFlowCoordinator(navigationController: UINavigationController(
            rootViewController: scanDummy
        )) // Временно, пока некуда сканер запихнуть

        mainScreenCoordinator.start()
        favoritesScreenCoordinator.start()
        profileScreenCoordinator.start()
        scanCoordinator.start() // Временно, пока некуда сканер запихнуть

        scanDummy.coordinator = scanCoordinator // Временно, пока некуда сканер запихнуть

        childCoordinators.append(mainScreenCoordinator)
        childCoordinators.append(favoritesScreenCoordinator)
        childCoordinators.append(profileScreenCoordinator)
        childCoordinators.append(scanCoordinator) // Временно, пока некуда сканер запихнуть

        mainTabBarController.viewControllers = [mainScreenCoordinator.navigationController,
                                                favoritesScreenCoordinator.navigationController,
                                                profileScreenCoordinator.navigationController,
                                                scanCoordinator.navigationController]
        mainTabBarController.setUpTabBarItems()

        navigationController.viewControllers = [mainTabBarController]
    }
}
