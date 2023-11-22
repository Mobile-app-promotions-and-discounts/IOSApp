import UIKit

final class MainScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}

    func navigateToCategoryScreen() {
        let viewModel = CategoryViewModel()
        let categoryVC = CategoryViewController(viewModel: viewModel)
        navigationController.pushViewController(categoryVC, animated: true)
    }
}
