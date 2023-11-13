import UIKit

protocol NavigationRouterProtocol {
//    func startNavigation()
}

final class NavigationRouter: NavigationRouterProtocol {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Пример использования
//    func startNavigation() {
//        let rootViewController = MainViewController(router: self)
//        navigationController.pushViewController(rootViewController, animated: false)
//    }
}
