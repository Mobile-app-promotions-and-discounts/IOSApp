import Combine
import Foundation

final class PromotionsScreenViewModel: ProductListViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private (set) var products: [Product] = []
    private (set) var viewState: CurrentValueSubject<ViewState, Never>
    private (set) var productService: ProductNetworkServiceProtocol

    init(productService: ProductNetworkServiceProtocol) {
        self.productService = productService
        self.products = productService.promotionListUpdate.value.map { $0.convertToProductModel() }

        if products.isEmpty {
            viewState = CurrentValueSubject<ViewState, Never>(.empty)
        } else {
            viewState = CurrentValueSubject<ViewState, Never>(.dataPresent)
        }
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return ProductCellUIModel(product: product)
    }

    func getTitle() -> String {
        return "Акции на этой неделе"
    }

    func getProductById(_ id: Int) -> Product? {
        return nil
    }

    func loadNextPage() {}

    func likeButtonTapped(for productID: Int) {
        guard let productIndex = products.firstIndex(where: { $0.id == productID }) else {
            ErrorHandler.handle(error: .customError("Продукт с ID \(productID) не найден"))
            return
        }

        let product = products[productIndex]
        if product.isFavorite {
            productService.removeFromFavorites(productID: product.id)
        } else {
            productService.addToFavorites(productID: product.id)
        }
    }

    func didCloseScreen() {}

    func refresh() {}
}
