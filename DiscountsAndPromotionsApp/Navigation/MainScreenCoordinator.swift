import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let productService: ProductNetworkServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let promotionVisualService: PromotionVisualsService

    init(navigationController: UINavigationController,
         dataService: DataServiceProtocol,
         productService: ProductNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         promotionVisualService: PromotionVisualsService = PromotionVisualsService()) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.productService = productService
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

    func navigateToProductScreen(for product: Product) {
        let productViewModel = ProductCardViewModel(product: product,
                                                    productService: productService,
                                                    mockProfileService: profileService)
        let productVC = ProductCardViewController(viewModel: productViewModel)
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
