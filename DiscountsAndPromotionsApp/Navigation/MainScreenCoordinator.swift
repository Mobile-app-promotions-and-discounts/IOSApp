import UIKit

final class MainScreenCoordinator: SearchEnabledCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private (set) var productService: ProductNetworkServiceProtocol
    private (set) var categoryService: CategoryNetworkServiceProtocol
    private (set) var profileService: ProfileServiceProtocol
    private let promotionVisualService: PromotionVisualsService

    init(navigationController: UINavigationController,
         dataService: DataServiceProtocol,
         productService: ProductNetworkServiceProtocol,
         categoryService: CategoryNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         promotionVisualService: PromotionVisualsService = PromotionVisualsService()) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.productService = productService
        self.categoryService = categoryService
        self.profileService = profileService
        self.promotionVisualService = promotionVisualService
    }

    func start() {
        let mainViewModel = MainViewModel(dataService: dataService,
                                          categoryService: categoryService,
                                          prosuctService: productService,
                                          promotionVisualService: promotionVisualService)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func navigateToCategoryScreen(with category: Category) {
        let categoryViewModel = CategoryViewModel(dataService: productService,
                                                  profileService: profileService,
                                                  category: category)
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel)
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
