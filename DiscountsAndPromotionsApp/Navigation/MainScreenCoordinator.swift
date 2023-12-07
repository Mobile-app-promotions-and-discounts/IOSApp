import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let promotionVisualService: PromotionVisualsService

    init(navigationController: UINavigationController,
         dataService: DataServiceProtocol,
         profileService: ProfileServiceProtocol,
         promotionVisualService: PromotionVisualsService = PromotionVisualsService()) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.profileService = profileService
        self.promotionVisualService = promotionVisualService
    }

    func start() {
        let mainViewModel = MainViewModel(dataService: dataService,
                                          promotionVisualService: promotionVisualService)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func navigateToCategoryScreen() {
        let categoryViewModel = CategoryViewModel(dataService: dataService, profileService: profileService)
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel)
        categoryViewController.coordinator = self
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    func navigateToSearchScreen() {
        let searchController = SearchViewController()
        searchController.coordinator = self
        navigationController.pushViewController(searchController, animated: true)
    }

    func navigateToSearchResultsScreen(for prompt: String) {
        let categoryViewModel = CategoryViewModel(dataService: dataService, profileService: profileService)
        let searchResultsController = SearchResultsViewController(viewModel: categoryViewModel)
        searchResultsController.coordinator = self
        navigationController.pushViewController(searchResultsController, animated: true)
    }

    func navigateToProductScreen(for product: Product) {
        let productVC = ProductCardViewController(product: product)
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }

    func navigateToMainScreen() {
        navigationController.popToRootViewController(animated: true)
    }

    func navigateToAllDetailsScreen(with type: MainSection) {
        switch type {
        case .promotions:
            ErrorHandler.handle(error: .profileError("Нажата кнопка Все на секции с акциями"))
        case .stores:
            let viewModel = AllStoresViewModel(dataService: dataService)
            let viewController = AllStoresViewController(viewModel: viewModel)
            viewController.scanCoordinator = scanCoordinator
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        case .categories:
            break
        }
    }
}
