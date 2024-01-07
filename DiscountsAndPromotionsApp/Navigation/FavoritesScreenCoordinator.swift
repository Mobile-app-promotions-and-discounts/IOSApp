import UIKit

final class FavoritesScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol

    init(navigationController: UINavigationController,
         dataService: DataServiceProtocol,
         profileService: ProfileServiceProtocol) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.profileService = profileService
    }

    func start() {
        let viewModel = FavoritesViewModel(dataService: dataService, profileService: profileService)
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        favoritesViewController.coordinator = self
        navigationController.pushViewController(favoritesViewController, animated: false)
    }

    func navigateToFavoriteProductScreen(for product: Product) {
        let productViewModel = ProductCardViewModel(product: product, mockProfileService: profileService)
        let productVC = ProductCardViewController(viewModel: productViewModel)
        productVC.hidesBottomBarWhenPushed = true
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
}
