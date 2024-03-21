import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol

    private let networkClient: NetworkClientProtocol
    private let authService: AuthServiceProtocol
    private let userNetworkService: UserNetworkServiceProtocol
    private let categoryNetworkService: CategoryNetworkServiceProtocol
    private let productNetworkService: ProductNetworkServiceProtocol
    private let storesNetworkService: StoreNetworkServiceProtocol
    private let myReviewsService: MyReviewServiceProtocol

    init(navigationController: UINavigationController, networkClient: NetworkClientProtocol = NetworkClient()) {
        self.dataService = MockDataService()
        self.profileService = MockProfileService()

        // Network Services
        self.networkClient = networkClient
        self.authService = AuthService(networkClient: networkClient)
        self.userNetworkService = UserNetworkService(networkClient: networkClient)
        self.categoryNetworkService = CategoryNetworkService(networkClient: networkClient)
        self.productNetworkService = ProductNetworkService(networkClient: networkClient,
                                                           categoryService: categoryNetworkService)
        self.storesNetworkService = StoreNetworkService(networkClient: networkClient)
        self.myReviewsService = MyReviewService(networkClient: networkClient)

        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }

    func start() {
        let splashViewController = SplashViewController(authService: authService)
        splashViewController.coordinator = self
        navigationController.viewControllers = [splashViewController]
    }

    func navigateToMainScreen() {
        let mainTabBarController = MainTabBarController()
        configureChildCoordinators(with: mainTabBarController)
        navigationController.viewControllers = [mainTabBarController]
    }

    func navigateToAuthScreen() {
        let authCoordinator = AuthCoordinator(authService: authService,
                                              userNetworkService: userNetworkService)
        let authViewController = AuthViewController()
        authViewController.coordinator = authCoordinator
        authCoordinator.mainCoordinator = self
        navigationController.viewControllers = [authViewController]
    }

    private func configureChildCoordinators(with  tabBarController: MainTabBarController) {
        // MARK: - Создание и запуск дочерних координаторов
        let scanCoordinator = ScanFlowCoordinator(navigationController: navigationController,
                                                  productService: productNetworkService,
                                                  profileService: profileService)

        let mainScreenNavigationController = GenericNavigationController()
        mainScreenNavigationController.scanCoordinator = scanCoordinator
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: mainScreenNavigationController,
                                                          dataService: dataService,
                                                          productService: productNetworkService,
                                                          storeService: storesNetworkService,
                                                          categoryService: categoryNetworkService,
                                                          profileService: profileService)
        scanCoordinator.mainScreenCoordinator = mainScreenCoordinator

        let favoritesScreenNavigationController = GenericNavigationController()
        favoritesScreenNavigationController.scanCoordinator = scanCoordinator
        let favoritesScreenCoordinator = FavoritesScreenCoordinator(navigationController: favoritesScreenNavigationController,
                                                                    profileService: profileService,
                                                                    productService: productNetworkService)
        let profileScreenCoordinator = ProfileScreenCoordinator(
            navigationController: UINavigationController(),
            userNetworkService: userNetworkService,
            authService: authService,
            myReviewsService: myReviewsService)
        profileScreenCoordinator.mainCoordinator = self

        mainScreenCoordinator.start()
        favoritesScreenCoordinator.start()
        profileScreenCoordinator.start()

        childCoordinators.removeAll()
        childCoordinators.append(contentsOf: [mainScreenCoordinator,
                                              favoritesScreenCoordinator,
                                              profileScreenCoordinator] as [Coordinator])

        tabBarController.viewControllers = childCoordinators.map { $0.navigationController }
        tabBarController.setUpTabBarItems()
    }
}
