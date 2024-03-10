import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        delegate = self
    }

    // Настройка вкладок UITabBarController
    func setUpTabBarItems() {
        guard let viewControllers = viewControllers, viewControllers.count >= 3 else {
            print("Ошибка: недостаточно viewControllers")
            return
        }

        let mainTitle = NSLocalizedString("Main", tableName: "MainFlow", comment: "")
        let favoritesTitle = NSLocalizedString("Favorites", tableName: "MainFlow", comment: "")
        let profileTitle = NSLocalizedString("Profile", tableName: "MainFlow", comment: "")

        let mainImage = UIImage.mainIcon
        let favoritesImage = UIImage.favoritesIcon
        let profileImage = UIImage.profileIcon

        viewControllers[0].tabBarItem = UITabBarItem(title: mainTitle, image: mainImage, tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(title: favoritesTitle, image: favoritesImage, tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(title: profileTitle, image: profileImage, tag: 2)

        setupUI()
    }

    private func setupUI() {
        let cornerRadius = CornerRadius.regular.cgFloat()

        tabBar.barStyle = .black
        tabBar.isTranslucent = true
        tabBar.barTintColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = .cherryMainAccent
        tabBar.unselectedItemTintColor = .cherrySBPlaceholder
        tabBar.backgroundColor = .cherryWhite
        tabBar.layer.cornerRadius = cornerRadius
        tabBar.clipsToBounds = true

        let tabBarFrame = CGRect(origin: CGPoint(x: tabBar.bounds.minX,
                                             y: tabBar.bounds.minY - cornerRadius),
                                 size: CGSize(width: tabBar.bounds.width,
                                              height: tabBar.bounds.height + cornerRadius))

        if let items = tabBar.items {
            for item in items {
                let font = [NSAttributedString.Key.font: CherryFonts.headerSmall]
                item.setTitleTextAttributes(font as [NSAttributedString.Key: Any], for: .normal)
                item.setBadgeTextAttributes(font as [NSAttributedString.Key: Any], for: .selected)
                let offsetSize: CGFloat = 8
                var textOffset = UIOffset()
                textOffset.vertical = offsetSize
                item.titlePositionAdjustment = textOffset
                var inset = UIEdgeInsets()
                inset.top = offsetSize
                inset.bottom = -offsetSize
                item.imageInsets = inset
            }
        }

        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = (tabBarFrame.width - tabBar.itemWidth * 3 - 104) / 2
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            if  let navController = viewControllers?[1] as? GenericNavigationController,
                let favoritesVC = navController.viewControllers.first as? FavoritesViewController,
                let coordinator = favoritesVC.coordinator as? FavoritesScreenCoordinator {
                coordinator.refresh()
            }
        }
    }
}
