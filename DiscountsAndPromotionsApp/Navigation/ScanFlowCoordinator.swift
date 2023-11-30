import UIKit

final class ScanFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    // вынес из функции чтобы вьюконтроллер не исчезал из памяти и кнопка работала
    private var scanVC: ScanViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func showScanner() {
        let captureSessionController = ScanCaptureSessionController(coordinator: self)
        let viewModel = ScanFlowViewModel()
        scanVC = ScanViewController(viewModel: viewModel,
                                        captureSessionController: captureSessionController,
                                        scanPreviewLayer: captureSessionController.previewLayer)

        guard let scanVC else {
            scanError()
            return
        }

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
