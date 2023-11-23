import UIKit

final class FavoritesScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let favoritesViewController = FavoritesViewController()
        navigationController.pushViewController(favoritesViewController, animated: false)
    }
}
