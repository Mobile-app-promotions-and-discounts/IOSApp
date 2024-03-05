import Foundation
import Combine

final class ProductCardViewModel: ProductCardViewModelProtocol {
    private let productService: ProductNetworkServiceProtocol
    private let product: Product

    init(product: Product, productService: ProductNetworkServiceProtocol) {
        self.productService = productService
        self.product = product
    }

    func getUIModel() -> ProductUIModel? {
        return ProductUIModel(product: product)
    }
}
