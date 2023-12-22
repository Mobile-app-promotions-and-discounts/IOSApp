import Combine
import Foundation

final class SearchResultsViewModel: CategoryViewModelProtocol {
    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol

    var productsUpdate = PassthroughSubject<[Product], Never>()
    private var subscriptions = Set<AnyCancellable>()

    private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    init(dataService: DataServiceProtocol,
         profileService: ProfileServiceProtocol,
         searchText: String) {
        self.dataService = dataService
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

    private func setupBindings(for prompt: String) {
            dataService.actualGoodsList
                .sink { [weak self] goodsList in
                    guard let self = self else { return }
                    let sortedGoodsList = goodsList.filter { product in
                        return product.name.lowercased().contains(prompt.lowercased())
                    }
                    self.products = sortedGoodsList
                }
                .store(in: &subscriptions)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
