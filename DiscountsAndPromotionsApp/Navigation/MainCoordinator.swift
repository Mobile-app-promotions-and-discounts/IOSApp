import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol

    private let networkClient: NetworkClientProtocol
    private let authService: AuthServiceProtocol
    private let userNetworkService: UserNetworkServiceProtocol
    private let categoryNetworkService: CategoryNetworkService
    private let productNetworkService: ProductNetworkService

    init(navigationController: UINavigationController, networkClient: NetworkClientProtocol = NetworkClient()) {
        self.dataService = MockDataService()
        self.profileService = MockProfileService()

        // Network Services
        self.networkClient = networkClient
        self.authService = AuthService(networkClient: networkClient)
        self.userNetworkService = UserNetworkService(networkClient: networkClient)
        self.categoryNetworkService = CategoryNetworkService(networkClient: networkClient)
        self.productNetworkService = ProductNetworkService(networkClient: networkClient)

        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        // ВРЕМЕННО - тест сервиса
        categoryNetworkService.fetchCategories()
        productNetworkService.getProduct(productID: 5)

        let mainTabBarController = MainTabBarController()
        configureChildCoordinators(with: mainTabBarController)
        navigationController.viewControllers = [mainTabBarController]
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
