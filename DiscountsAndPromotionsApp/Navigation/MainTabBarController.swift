import UIKit

final class MainTabBarController: UITabBarController {

    // Настройка вкладок UITabBarController
    func setUpTabBarItems() {
        guard let viewControllers = viewControllers, viewControllers.count >= 4 else {
            print("Ошибка: недостаточно viewControllers")
            return
        }

        let mainTitle = NSLocalizedString("Main", tableName: "MainFlow", comment: "")
        let favoritesTitle = NSLocalizedString("Favorites", tableName: "MainFlow", comment: "")
        let profileTitle = NSLocalizedString("Profile", tableName: "MainFlow", comment: "")
        let scanTitle = NSLocalizedString("Scan", tableName: "MainFlow", comment: "")

        let mainImage = UIImage.mainIcon
        let favoritesImage = UIImage.favoritesIcon
        let profileImage = UIImage.profileIcon
        let scanImage = UIImage(systemName: "barcode.viewfinder")

        viewControllers[0].tabBarItem = UITabBarItem(title: mainTitle, image: mainImage, tag: 0)
        viewControllers[1].tabBarItem = UITabBarItem(title: favoritesTitle, image: favoritesImage, tag: 1)
        viewControllers[2].tabBarItem = UITabBarItem(title: profileTitle, image: profileImage, tag: 2)
        viewControllers[3].tabBarItem = UITabBarItem(title: scanTitle, image: scanImage, tag: 3)
    }
}
