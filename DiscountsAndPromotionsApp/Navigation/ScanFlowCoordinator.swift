import UIKit

final class ScanFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    // вынес из функции чтобы вьюконтроллер не исчезал из памяти и кнопка работала
    private var scanVC: ScanViewController?

    private var productService: ProductNetworkServiceProtocol

    init(navigationController: UINavigationController,
         productService: ProductNetworkServiceProtocol) {
        self.navigationController = navigationController
        self.productService = productService
    }

    func start() {

    }

    func showScanner() {
        let captureSessionController = ScanCaptureSessionController(coordinator: self)
        let viewModel = ScanFlowViewModel(productService: productService,
                                          coordinator: self)
        scanVC = ScanViewController(viewModel: viewModel,
                                        captureSessionController: captureSessionController,
                                        scanPreviewLayer: captureSessionController.previewLayer)

        guard let scanVC else {
            scanError()
            return
        }

        scanVC.coordinator = self
        scanVC.hidesBottomBarWhenPushed = true
        scanVC.modalPresentationStyle = .fullScreen
        navigationController.show(scanVC, sender: nil)
    }

    func scanError() {
        ErrorHandler.handle(error: .barcodeScanError)
    }

    func navigateToMainScreen() {
        navigationController.popToRootViewController(animated: true)
        navigationController.navigationBar.isHidden = true
    }

    func navigateToEmptyResultScreen() {
        let emptyVC = EmptyScanResultViewController()
        emptyVC.coordinator = self
        navigationController.pushViewController(emptyVC, animated: true)
    }

    func showProduct(_ product: Product) {
        let productVC = ProductCardViewController(product: product)
        productVC.hidesBottomBarWhenPushed = true
        productVC.coordinator = self
        navigationController.show(productVC, sender: nil)
        navigationController.navigationBar.isHidden = true
    }
}
