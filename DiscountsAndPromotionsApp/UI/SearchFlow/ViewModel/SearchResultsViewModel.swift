import Combine
import Foundation

final class SearchResultsViewModel: ProductListViewModelProtocol {
    private let productService: ProductNetworkServiceProtocol
    private let profileService: ProfileServiceProtocol
    private (set) var viewState = CurrentValueSubject<ViewState, Never>(.loading)

    private var currentPage = 0
    private var isOnLastPage = false
    private var isFetchingData = false
    private var searchText = ""

    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private var subscriptions = Set<AnyCancellable>()

    private (set) var products = [Product]() {
        didSet {
            productsUpdate.send(products.count)
            viewState.value = products.isEmpty ? .empty : .dataPresent
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
        if !isOnLastPage && !isFetchingData {
            isFetchingData = true

            productService.getProducts(categoryID: nil,
                                       searchItem: searchText,
                                       page: currentPage + 1)
        }
    }

    func didCloseScreen() {
        productService.cancel()
    }

    private func setupBindings(for prompt: String) {
        searchText = prompt

        productService.productListUpdate
        .sink { [weak self] products in
            let newProducts = products.map { $0.convertToProductModel() }
            self?.products.append(contentsOf: newProducts)
        }
        .store(in: &subscriptions)

        productService.paginationPublisher
            .sink { [weak self] paginationState in
                self?.isOnLastPage = paginationState.isLastPage
                self?.currentPage = paginationState.currentPage
                self?.isFetchingData = false
            }
            .store(in: &subscriptions)

        productService.productListUpdate
            .sink { [weak self] searchResponse in
                guard let self = self else { return }

                self.products = searchResponse.map { $0.convertToProductModel() }
            }
            .store(in: &subscriptions)

        loadNextPage()
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
