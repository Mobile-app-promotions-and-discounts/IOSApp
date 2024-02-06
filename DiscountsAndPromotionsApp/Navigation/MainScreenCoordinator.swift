import UIKit

final class MainScreenCoordinator: SearchEnabledCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private (set) var productService: ProductNetworkServiceProtocol
    private (set) var categoryService: CategoryNetworkServiceProtocol
    private (set) var storeService: StoreNetworkServiceProtocol
    private (set) var profileService: ProfileServiceProtocol
    private let promotionVisualService: PromotionVisualsService

    init(navigationController: UINavigationController,
         dataService: DataServiceProtocol,
         productService: ProductNetworkServiceProtocol,
         storeService: StoreNetworkServiceProtocol,
         categoryService: CategoryNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         promotionVisualService: PromotionVisualsService = PromotionVisualsService()) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.productService = productService
        self.storeService = storeService
        self.categoryService = categoryService
        self.profileService = profileService
        self.promotionVisualService = promotionVisualService
    }

    func start() {
        let mainViewModel = MainViewModel(dataService: dataService,
                                          categoryService: categoryService,
                                          prosuctService: productService,
                                          storesService: storeService,
                                          promotionVisualService: promotionVisualService)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func navigateToCategoryScreen(with category: Category) {
        let categoryViewModel = CategoryScreenViewModel(dataService: productService,
                                                  profileService: profileService,
                                                  category: category)
        let categoryViewController = ProductListViewController(viewModel: categoryViewModel)
        categoryViewController.coordinator = self
        categoryViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    func navigateToSearchScreen() {
        let viewModel = SearchViewModel(dataService: dataService, productService: productService)
        let searchController = SearchViewController(viewModel: viewModel)
        searchController.coordinator = self
        navigationController.pushViewController(searchController, animated: true)
    }

    func navigateToSearchResultsScreen(for prompt: String) {
        let viewModel = SearchResultsViewModel(productService: productService,
                                               profileService: profileService,
                                               searchText: prompt)
        let searchResultsController = SearchResultsViewController(viewModel: viewModel)
        searchResultsController.coordinator = self
        navigationController.pushViewController(searchResultsController, animated: true)
    }

    func navigateToMainScreen() {
        navigationController.popToRootViewController(animated: true)
    }

    func navigateToAllDetailsScreen(with type: MainSection) {
        switch type {
        case .promotions:
            let viewModel = PromotionsScreenViewModel(productService: productService)
            let promotionsViewController = ProductListViewController(viewModel: viewModel)
            promotionsViewController.coordinator = self
            promotionsViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(promotionsViewController, animated: true)
        case .stores:
            let viewModel = AllStoresViewModel(storesService: storeService)
            let viewController = AllStoresViewController(viewModel: viewModel)
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        case .categories:
            break
        }
    }
}
