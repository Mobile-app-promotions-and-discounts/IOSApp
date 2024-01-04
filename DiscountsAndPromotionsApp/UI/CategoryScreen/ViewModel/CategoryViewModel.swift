import Foundation
import Combine

final class CategoryViewModel: CategoryViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<Int, Never>()
    private (set) var products: [Product] = [] {
        didSet {
            print("NEW COUNT: \(products.count)")
            productsUpdate.send(products.count)

        }
    }

    private let dataService: ProductNetworkServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let categoryID: Int
    private var categoryName: String?

    private var currentPage = 0
    private var isOnLastPage = false
    private var isFetchingData = false

    private var cancellables = Set<AnyCancellable>()

    init(dataService: ProductNetworkServiceProtocol, profileService: ProfileServiceProtocol, categoryID: Int) {
        self.dataService = dataService
        self.profileService = profileService
        self.categoryID = categoryID
        setupBindings()
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    func getTitle() -> String {
        if let name = categoryName {
            return NSLocalizedString(name, tableName: "MainFlow", comment: "")
        }
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

            dataService.getProducts(categoryID: categoryID + 1,
                                    searchItem: nil,
                                    page: currentPage + 1)
        }
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
