import UIKit

final class SearchFlowCoordinator: Coordinator {
    static let shared = SearchFlowCoordinator()

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private init(navigationController: UINavigationController = GenericNavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        let searchController = SearchViewController()
        searchController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(searchController, animated: true)
    }
}
