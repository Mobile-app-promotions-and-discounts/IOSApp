import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var scanCoordinator: ScanFlowCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.scanCoordinator = scanCoordinator
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }

    func navigateToCategoryScreen() {
        let categoryViewModel = CategoryViewModel()
        let categoryViewController = CategoryViewController(viewModel: categoryViewModel)
        categoryViewController.coordinator = self
        navigationController.pushViewController(categoryViewController, animated: true)
    }

    func navigateToSearchScreen() {
        let searchController = SearchViewController()
        navigationController.pushViewController(searchController, animated: true)
    }
}
