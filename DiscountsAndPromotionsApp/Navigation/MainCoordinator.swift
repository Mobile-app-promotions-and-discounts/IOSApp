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
        let mainTabBarController = MainTabBarController()
        configureChildCoordinators(with: mainTabBarController)
        navigationController.viewControllers = [mainTabBarController]
    }

    private func configureChildCoordinators(with tabBarController: MainTabBarController) {
        // Создание и запуск дочерних координаторов
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: GenericNavigationController(),
                                                          dataService: dataService,
                                                          profileService: profileService)
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: GenericNavigationController(),
                                                                    dataService: dataService,
                                                                    profileService: profileService)
        let profileScreenCoordinator = ProfileScreenCoordinator(navigationController: UINavigationController())
        let scanCoordinator = ScanFlowCoordinator(navigationController: navigationController)
        mainScreenCoordinator.scanCoordinator = scanCoordinator
        favoritesScreenCoordinator.scanCoordinator = scanCoordinator

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
