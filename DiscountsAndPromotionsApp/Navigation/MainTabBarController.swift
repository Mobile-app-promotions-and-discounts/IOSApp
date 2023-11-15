import UIKit

final class MainTabBarController: UITabBarController {
    private let router: NavigationRouterProtocol

    init(router: NavigationRouterProtocol) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        setUpViewControllers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViewControllers() {
        let mainViewController = MainViewController(router: self.router)
        mainViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("main", comment: ""),
                                                     image: UIImage(systemName: "mustache"),
                                                     tag: 0)

        let catalogController = CatalogViewController(router: self.router)
        catalogController.tabBarItem = UITabBarItem(title: NSLocalizedString("catalog", comment: ""),
                                                    image: UIImage(systemName: "list.bullet.rectangle"),
                                                    tag: 1)

        let favoritesController = FavoritesViewController(router: self.router)
        favoritesController.tabBarItem = UITabBarItem(title: NSLocalizedString("favorites", comment: ""),
                                                      image: UIImage(systemName: "star.fill"),
                                                      tag: 2)

        let profileController = ProfileViewController(router: self.router)
        profileController.tabBarItem = UITabBarItem(title: NSLocalizedString("profile", comment: ""),
                                                    image: UIImage(systemName: "person.crop.circle"),
                                                    tag: 3)

        viewControllers = [mainViewController, catalogController, favoritesController, profileController]
    }
}
