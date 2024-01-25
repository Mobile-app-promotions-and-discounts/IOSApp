import Foundation
import Combine

class ProductListViewModel: ProductListViewModelProtocol {
    private (set) var viewState = CurrentValueSubject<ViewState, Never>(.loading)
    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private (set) var products: [Product] = [] {
        didSet {
            productsUpdate.send(products.count)
            viewState.value = products.isEmpty ? .empty : .dataPresent
        }
    }

    private (set) var productService: ProductNetworkServiceProtocol
    private (set) var profileService: ProfileServiceProtocol

    private (set) var currentPage = 0
    private (set) var isOnLastPage = false
    private (set) var isFetchingData = false

    private var cancellables = Set<AnyCancellable>()

    init(dataService: ProductNetworkServiceProtocol, profileService: ProfileServiceProtocol) {
        self.productService = dataService
        self.profileService = profileService
        setupBindings()
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    func getTitle() -> String {
        return ""
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
            nextPageAction()
        }
    }

    func didCloseScreen() {
        productService.cancel()
    }

    func nextPageAction() { }

    private func setupBindings() {
        productService.productListUpdate
        .sink { [weak self] products in
            let newProducts = products.map { $0.convertToProductModel() }
            self?.products.append(contentsOf: newProducts)
        }
        .store(in: &cancellables)

        productService.paginationPublisher
            .sink { [weak self] paginationState in
                self?.isOnLastPage = paginationState.isLastPage
                self?.currentPage = paginationState.currentPage
                self?.isFetchingData = false
            }
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
