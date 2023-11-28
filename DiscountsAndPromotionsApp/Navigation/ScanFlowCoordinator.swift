import UIKit

protocol ScanFlowCoordinatorProtocol: AnyObject {
    func start()
    func showScanner()
    func goBack()
    func scanError()
}

final class ScanFlowCoordinator: Coordinator, ScanFlowCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var scanVC = UIViewController()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        scanVC = ScanViewController(coordinator: self)
        scanVC.hidesBottomBarWhenPushed = true
    }

    func showScanner() {
        navigationController.pushViewController(scanVC, animated: true)
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }

    func scanError() {
        let alert = UIAlertController(title: NSLocalizedString("barcodeFail", tableName: "ScanFlow", comment: ""),
                                   message: NSLocalizedString("barcodeFailMessage", tableName: "ScanFlow", comment: ""),
                                   preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.goBack()
        }))
        scanVC.present(alert, animated: true)
    }
}
