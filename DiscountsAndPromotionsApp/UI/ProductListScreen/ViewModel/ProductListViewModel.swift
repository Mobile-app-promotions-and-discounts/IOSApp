import Foundation
import Combine

final class ProductListViewModel: ProductListViewModelProtocol {
    private (set) var viewState = CurrentValueSubject<ViewState, Never>(.loading)
    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private (set) var products: [Product] = [] {
        didSet {
            productsUpdate.send(products.count)
            viewState.value = products.isEmpty ? .empty : .dataPresent
        }
    }

    private let dataService: ProductNetworkServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let category: Category

    private var currentPage = 0
    private var isOnLastPage = false
    private var isFetchingData = false

    private var cancellables = Set<AnyCancellable>()

    init(dataService: ProductNetworkServiceProtocol, profileService: ProfileServiceProtocol, category: Category) {
        self.dataService = dataService
        self.profileService = profileService
        self.category = category
        setupBindings()
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    func getTitle() -> String {
        return NSLocalizedString(category.name, tableName: "MainFlow", comment: "")
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

            dataService.getProducts(categoryID: category.id + 1,
                                    searchItem: nil,
                                    page: currentPage + 1)
        }
    }

    func didCloseScreen() {
        dataService.cancel()
    }

    private func setupBindings() {
        dataService.productListUpdate
        .sink { [weak self] products in
            let newProducts = products.map { $0.convertToProductModel() }
            self?.products.append(contentsOf: newProducts)
        }
        .store(in: &cancellables)

        dataService.paginationPublisher
            .sink { [weak self] paginationState in
                self?.isOnLastPage = paginationState.isLastPage
                self?.currentPage = paginationState.currentPage
                self?.isFetchingData = false
            }
            .store(in: &cancellables)

        loadNextPage()
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
