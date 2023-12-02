import UIKit

final class MainTabBarController: UITabBarController {

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
        tabBar.barStyle = .black
        tabBar.isTranslucent = true
        tabBar.barTintColor = .cherryWhite
        tabBar.backgroundColor = .cherryWhite
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = nil
        tabBar.tintColor = .cherryMainAccent
        tabBar.unselectedItemTintColor = .cherryGrayBlue

        let cornerRadius = CornerRadius.regular.cgFloat()
        let roundedBackground = UIView()
        roundedBackground.backgroundColor = .cherryWhite
        roundedBackground.layer.cornerRadius = cornerRadius
        let tabBarFrame = CGRect(origin: CGPoint(x: tabBar.bounds.minX,
                                             y: tabBar.bounds.minY - cornerRadius),
                                 size: CGSize(width: tabBar.bounds.width,
                                              height: tabBar.bounds.height + cornerRadius))
        roundedBackground.frame = tabBarFrame
        tabBar.addSubview(roundedBackground)
        tabBar.sendSubviewToBack(roundedBackground)

        if let items = tabBar.items {
            for item in items {
                let font = [NSAttributedString.Key.font: CherryFonts.headerSmall]
                item.setTitleTextAttributes(font as [NSAttributedString.Key: Any], for: .normal)
                item.setBadgeTextAttributes(font as [NSAttributedString.Key: Any], for: .selected)
            }
        }

        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = (tabBarFrame.width - tabBar.itemWidth * 3 - 104) / 2
    }
}
