import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var scanCoordinator: ScanFlowCoordinator?

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
