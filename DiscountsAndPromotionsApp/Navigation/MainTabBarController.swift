import UIKit

final class MainTabBarController: UITabBarController {
    weak var coordinator: MainCoordinator?
    
    //MARK: - временное решение для быстрой проверки сканера
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coordinator?.startScanFlow()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setUpViewControllers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViewControllers() {
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("main", comment: ""),
                                                     image: UIImage(systemName: "mustache"),
                                                     tag: 0)

        let catalogController = CatalogViewController()
        catalogController.tabBarItem = UITabBarItem(title: NSLocalizedString("catalog", comment: ""),
                                                    image: UIImage(systemName: "list.bullet.rectangle"),
                                                    tag: 1)

        let favoritesController = FavoritesViewController()
        favoritesController.tabBarItem = UITabBarItem(title: NSLocalizedString("favorites", comment: ""),
                                                      image: UIImage(systemName: "star.fill"),
                                                      tag: 2)

        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: NSLocalizedString("profile", comment: ""),
                                                    image: UIImage(systemName: "person.crop.circle"),
                                                    tag: 3)

        viewControllers = [mainViewController, catalogController, favoritesController, profileController]
    }
}
