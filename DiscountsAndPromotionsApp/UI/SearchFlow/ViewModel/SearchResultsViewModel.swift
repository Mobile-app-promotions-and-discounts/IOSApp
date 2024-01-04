import Combine
import Foundation

final class SearchResultsViewModel: CategoryViewModelProtocol {
    private let productService: ProductNetworkServiceProtocol
    private let profileService: ProfileServiceProtocol

    var productsUpdate = PassthroughSubject<Int, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private (set) var products = [Product]() {
        didSet {
            productsUpdate.send(products.count)
        }
    }

    init(productService: ProductNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         searchText: String) {
        self.productService = productService
        self.profileService = profileService

        setupBindings(for: searchText)
    }

    func numberOfItems() -> Int {
        return products.count
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    func getTitle() -> String {
        return "Результаты поиска"
    }

    func getProductById(_ id: Int) -> Product? {
        return products.first { $0.id == id }
    }

    func likeButtonTapped(for productID: Int) {
        guard let productIndex = products.firstIndex(where: { $0.id == productID }) else {
            ErrorHandler.handle(error: .customError("Продукт с ID \(productID) не найден"))
            return
        }

        let product = products[productIndex]
        if profileService.isFavorite(product) {
            profileService.removeFavorite(product)
        } else {
            profileService.addFavorite(product)
        }
    }

    func loadNextPage() {

    }

    private func setupBindings(for prompt: String) {
        productService.productListUpdate
            .sink { [weak self] searchResponse in
                guard let self = self else { return }

                self.products = searchResponse.map { $0.convertToProductModel() }
            }
            .store(in: &subscriptions)

        productService.getProducts(categoryID: nil,
                                   searchItem: prompt,
                                   page: nil)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
