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

    func navigateToCategoryScreen(with ID: Int) {
        let categoryViewModel = CategoryViewModel(dataService: dataService,
                                                  profileService: profileService,
                                                  categoryID: ID)
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel)
        categoryViewController.coordinator = self
        categoryViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    func navigateToSearchScreen() {
        let viewModel = SearchViewModel(dataService: dataService)
        let searchController = SearchViewController(viewModel: viewModel)
        searchController.coordinator = self
        navigationController.pushViewController(searchController, animated: true)
    }

    func navigateToSearchResultsScreen(for prompt: String) {
        let viewModel = SearchResultsViewModel(dataService: dataService,
                                               profileService: profileService,
                                               searchText: prompt)
        let searchResultsController = SearchResultsViewController(viewModel: viewModel)
        searchResultsController.coordinator = self
        navigationController.pushViewController(searchResultsController, animated: true)
    }

    func navigateToProductScreen(for product: Product) {
        let productVC = ProductCardViewController(product: product)
        productVC.hidesBottomBarWhenPushed = true
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
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        case .categories:
            break
        }
    }
}
