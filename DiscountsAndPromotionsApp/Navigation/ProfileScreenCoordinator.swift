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

    func navigateToEditProfileScreen() {
        let editProfileViewController = EditProfileViewController(viewModel: profileViewModel)
        navigationController.pushViewController(editProfileViewController, animated: true)
    }

    func navigateToRegionScreen() {
        let alert = UIAlertController(title: "Region", message: "📍", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToReviewsScreen() {
        let alert = UIAlertController(title: "Reviews", message: "⭐️⭐️⭐️⭐️⭐️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToNotificationsScreen() {
        let alert = UIAlertController(title: "Notifications", message: "📳", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToSupportScreen() {
        let alert = UIAlertController(title: "Support", message: "💬", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToDeleteAccountScreen() {
        let alert = UIAlertController(title: "Delete account", message: "☠️", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func navigateToExitAccountScreen() {
        let alert = UIAlertController(title: "Exit account", message: "👋🏻", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.present(alert, animated: true)
    }
}
