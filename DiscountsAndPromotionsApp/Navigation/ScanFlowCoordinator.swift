import UIKit

final class ScanFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    // вынес из функции чтобы вьюконтроллер не исчезал из памяти и кнопка работала
    private var scanVC: ScanViewController?
    private var productService: ProductNetworkServiceProtocol
    private var profileService: ProfileServiceProtocol

    init(navigationController: UINavigationController,
         productService: ProductNetworkServiceProtocol,
         profileService: ProfileServiceProtocol) {
        self.navigationController = navigationController
        self.productService = productService
        self.profileService = profileService
    }

    func start() { }

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
        DispatchQueue.main.async { [weak self] in
            let emptyVC = EmptyScanResultViewController()
            emptyVC.coordinator = self
            self?.navigationController.pushViewController(emptyVC, animated: true)
        }
    }

    func showProduct(_ product: Product) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let productViewModel = ProductCardViewModel(product: product,
                                                        productService: productService,
                                                        mockProfileService: profileService)
            let productVC = ProductCardViewController(viewModel: productViewModel)
            productVC.hidesBottomBarWhenPushed = true
            productVC.coordinator = self
            navigationController.navigationBar.isHidden = false
            navigationController.navigationBar.alpha = 0.0
            navigationController.pushViewController(productVC, animated: true)
        }
    }
}
