import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func navigateBack()
}

extension Coordinator {
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
}
