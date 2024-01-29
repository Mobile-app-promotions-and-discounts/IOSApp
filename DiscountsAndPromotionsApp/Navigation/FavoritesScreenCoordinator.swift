import UIKit

final class FavoritesScreenCoordinator: SearchEnabledCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private (set) var profileService: ProfileServiceProtocol
    private (set) var productService: ProductNetworkServiceProtocol

    init(navigationController: UINavigationController,
         profileService: ProfileServiceProtocol,
         productService: ProductNetworkServiceProtocol) {
        self.navigationController = navigationController
        self.profileService = profileService
        self.productService = productService
    }

    func start() {
        let viewModel = FavoritesViewModel(dataService: productService)
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        favoritesViewController.coordinator = self
        navigationController.pushViewController(favoritesViewController, animated: false)
    }

    func refresh() {
        let viewModel = FavoritesViewModel(dataService: productService)
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        favoritesViewController.coordinator = self
        navigationController.setViewControllers([favoritesViewController], animated: false)
    }

    func navigateToFavoriteProductScreen(for product: Product) {
        let productViewModel = ProductCardViewModel(product: product,
                                                    productService: productService)
        let productVC = ProductCardViewController(viewModel: productViewModel)
        productVC.hidesBottomBarWhenPushed = true
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }

    func navigateToMainScreen() {
        navigationController.popToRootViewController(animated: true)
    }

    func navigateToSearchResultsScreen(for prompt: String) {
        let viewModel = SearchResultsViewModel(productService: productService,
                                               profileService: profileService,
                                               searchText: prompt)
        let searchResultsController = SearchResultsViewController(viewModel: viewModel)
        searchResultsController.coordinator = self
        navigationController.pushViewController(searchResultsController, animated: true)
    }

    func navigateToSearchScreen() {}
}
