import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func navigateToCategoryScreen() {
        let categoryViewModel = CategoryViewModel()
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel)
        categoryViewController.coordinator = self
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    func navigateToProductScreen(for product: Product) {
        let productVC = ProductCardViewController(product: product)
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
}
