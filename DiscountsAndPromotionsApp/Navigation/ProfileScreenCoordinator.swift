import UIKit

final class ProfileScreenCoordinator: Coordinator {
    let profileViewModel = ProfileViewModel()

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.coordinator = self
        navigationController.pushViewController(profileViewController, animated: false)
    }

    func exit() {
        self.navigationController.navigationBar.isHidden = true
        navigationController.popViewController(animated: true)
    }

    func navigateToEditProfileScreen() {
        let editProfileViewController = EditProfileViewController(viewModel: profileViewModel)
        editProfileViewController.coordinator = self
        navigationController.pushViewController(editProfileViewController, animated: true)
    }

    func navigateToRegionScreen() {
        // Заглушка до реализации функционала
        let regionViewController = RegionViewController(viewModel: profileViewModel)
        regionViewController.coordinator = self
        navigationController.pushViewController(regionViewController, animated: true)
    }

    func navigateToReviewsScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Reviews", message: "⭐️⭐️⭐️⭐️⭐️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToNotificationsScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Notifications", message: "📳", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToSupportScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Support", message: "💬", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToDeleteAccountScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Delete account", message: "☠️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToExitAccountScreen() {
        // Заглушка до реализации функционала
        let alert = UIAlertController(title: "Exit account", message: "👋🏻", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }
}
