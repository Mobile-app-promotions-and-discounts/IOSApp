import UIKit

final class ProfileScreenCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let profileViewController = ProfileViewController(viewModel: ProfileViewModel())
        navigationController.pushViewController(profileViewController, animated: false)
    }
}
