import Combine
import Foundation

final class PromotionsScreenViewModel: ProductListViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private (set) var products: [Product] = [] {
        didSet {
            productsUpdate.send(products.count)
            viewState.value = products.isEmpty ? .empty : .dataPresent
        }
    }
    private (set) var viewState: CurrentValueSubject<ViewState, Never>
    private (set) var productService: ProductNetworkServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(productService: ProductNetworkServiceProtocol) {
        self.productService = productService
        self.products = productService.promotionListUpdate.value.map { $0.convertToProductModel() }

        if products.isEmpty {
            viewState = CurrentValueSubject<ViewState, Never>(.empty)
        } else {
            viewState = CurrentValueSubject<ViewState, Never>(.dataPresent)
        }

        setupBindings()
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return ProductCellUIModel(product: product)
    }

    func getTitle() -> String {
        return "Акции на этой неделе"
    }

    func getProductById(_ id: Int) -> Product? {
        return products.first { $0.id == id }
    }

    func loadNextPage() {}

    func updateFavoriteStatus(productID: Int, isFavorite: Bool) {
        if let index = products.firstIndex(where: { $0.id == productID }) {
            let product = products[index]
            let newProduct = Product(id: productID,
                                     barcode: product.barcode,
                                     name: product.name,
                                     description: product.description,
                                     category: product.category,
                                     image: product.image,
                                     rating: product.rating,
                                     offers: product.offers,
                                     isFavorite: isFavorite)
            products[index] = newProduct
        }
    }

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

    func didCloseScreen() {
        productService.cancel()
    }

    func refresh() {}

    private func setupBindings() {
        productService.isFavoriteUpdate
            .sink { [weak self] productID, isFavorite in
                self?.updateFavoriteStatus(productID: productID, isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }
}
