import UIKit

final class MainTabBarController: UITabBarController {

    // Настройка вкладок UITabBarController
    func setUpTabBarItems() {
        guard let viewControllers = viewControllers else {
            print("Ошибка с viewControllers")
            return
        }

        let items = ["main", "favorites", "profile", "Scan"]
        let images = [UIImage.mainIcon,
                      UIImage.favoritesIcon,
                      UIImage.profileIcon,
                      UIImage(systemName: "barcode.viewfinder")]

        for (index, viewController) in viewControllers.enumerated() {
            let title = NSLocalizedString(items[index], comment: "")
            let image = images[index]
            viewController.tabBarItem = UITabBarItem(title: title, image: image, tag: index)
        }
    }
}
