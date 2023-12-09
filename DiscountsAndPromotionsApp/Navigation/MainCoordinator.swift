import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol

    init(navigationController: UINavigationController) {
        self.dataService = MockDataService()
        self.profileService = MockProfileService()
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let splashViewController = SplashViewController()
        splashViewController.coordinator = self
        navigationController.viewControllers = [splashViewController]
    }

    func navigateToMainScreen() {
        // ВРЕМЕННО - тест сервиса
        AuthService.shared.getToken(for: NetworkBaseConfiguration.testUser)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            UserNetworkService.shared.fetchUser()
        })

        let mainTabBarController = MainTabBarController()
        configureChildCoordinators(with: mainTabBarController)
        navigationController.viewControllers = [mainTabBarController]
    }

    func navigateToAuthScreen(from splashViewController: UIViewController) {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        loginViewController.modalPresentationStyle = .custom
        loginViewController.transitioningDelegate = splashViewController as? any UIViewControllerTransitioningDelegate
        splashViewController.present(loginViewController, animated: true)
    }

    private func configureChildCoordinators(with tabBarController: MainTabBarController) {
        // Создание и запуск дочерних координаторов
        let scanCoordinator = ScanFlowCoordinator(navigationController: navigationController)

        let mainScreenNavigationController = GenericNavigationController()
        mainScreenNavigationController.scanCoordinator = scanCoordinator
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: mainScreenNavigationController,
                                                          dataService: dataService,
                                                          profileService: profileService)

        let favoritesScreenNavigationController = GenericNavigationController()
        favoritesScreenNavigationController.scanCoordinator = scanCoordinator
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: favoritesScreenNavigationController,
                                                                    dataService: dataService,
                                                                    profileService: profileService)
        let profileScreenCoordinator = ProfileScreenCoordinator(navigationController: UINavigationController())

        mainScreenCoordinator.start()
        favoritesScreenCoordinator.start()
        profileScreenCoordinator.start()

        childCoordinators.append(contentsOf: [mainScreenCoordinator,
                                              favoritesScreenCoordinator,
                                              profileScreenCoordinator] as [Coordinator])

        tabBarController.viewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setUpTabBarItems()
    }
}
