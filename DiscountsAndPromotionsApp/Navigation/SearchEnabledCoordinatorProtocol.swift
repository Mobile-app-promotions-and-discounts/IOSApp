import UIKit

protocol SearchEnabledCoordinator: Coordinator, AnyObject {
    var productService: ProductNetworkServiceProtocol { get }
    var profileService: ProfileServiceProtocol { get }

    func navigateToMainScreen()
    func navigateToSearchScreen()
    func navigateToProductScreen(for product: Product)
}

extension SearchEnabledCoordinator {
    func navigateToProductScreen(for product: Product) {
        let productViewModel = ProductCardViewModel(product: product,
                                                    productService: productService,
                                                    mockProfileService: profileService)
        let productVC = ProductCardViewController(viewModel: productViewModel)
        productVC.hidesBottomBarWhenPushed = true
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
}
