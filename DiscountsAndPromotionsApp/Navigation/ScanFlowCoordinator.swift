import UIKit

final class ScanFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func showScanner() {
        let captureSessionController = ScanCaptureSessionController(coordinator: self)
        let viewModel = ScanFlowViewModel()
        let scanVC = ScanViewController(viewModel: viewModel,
                                        captureSessionController: captureSessionController,
                                        scanPreviewLayer: captureSessionController.previewLayer)
        scanVC.coordinator = self
        scanVC.hidesBottomBarWhenPushed = true

        let scanNavigationController = UINavigationController(rootViewController: scanVC)
        scanNavigationController.modalPresentationStyle = .fullScreen

        navigationController.show(scanNavigationController, sender: nil)
    }

    func goBack() {
        navigationController.dismiss(animated: true)
    }

    func scanError() {
        ErrorHandler.handle(error: .barcodeScanError)
    }
}
