import UIKit

protocol ScanFlowCoordinatorProtocol: AnyObject {
    func start()
    func showScanner()
    func goBack()
    func scanError()
}

final class ScanFlowCoordinator: ScanFlowCoordinatorProtocol {
    var scanVC = UIViewController()
    private var scanNavigationController = UINavigationController()

    func start() {
        scanVC = ScanViewController(coordinator: self)
        scanVC.hidesBottomBarWhenPushed = true
    }

    func showScanner() {
        scanNavigationController = UINavigationController(rootViewController: scanVC)
        scanNavigationController.modalPresentationStyle = .fullScreen
        UIViewController.topMostViewController()?.show(scanNavigationController, sender: nil)
    }

    func goBack() {
        scanNavigationController.dismiss(animated: true)
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
