import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var scanCoordinator: ScanFlowCoordinator?

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
            let mainViewModel = MainViewModel(dataService: dataService)
            let mainViewController = MainViewController(viewModel: mainViewModel)
            mainViewController.scanCoordinator = scanCoordinator
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
            navigationController.pushViewController(searchController, animated: true)
        }
    }
