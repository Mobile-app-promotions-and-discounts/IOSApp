import UIKit

protocol NavigationRouterProtocol {
    func startNavigation()
}

final class NavigationRouter: NavigationRouterProtocol {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startNavigation() {
        let tabBarController = MainTabBarController(router: self)
        navigationController.pushViewController(tabBarController, animated: false)
    }
}
