import Foundation
import Combine

final class CategoryViewModel: CategoryViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()

    private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    private let dataService: DataServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let categoryID: Int
    private var categoryName: String?

    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol, profileService: ProfileServiceProtocol, categoryID: Int) {
        self.dataService = dataService
        self.profileService = profileService
        self.categoryID = categoryID
        setupBindings()
    }

    func numberOfItems() -> Int {
        return products.count
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

    private func setupBindings() {
        // Доработать под каждую категорию, с новым методом в дата сервисе
        dataService.actualGoodsList
            .sink { [weak self] goodsList in
                guard let self = self else { return }

                // Фильтрация продуктов по категории
                let sortedGoodsList = goodsList.filter { product in
                    product.category.id == self.categoryID
                }
                self.products = sortedGoodsList

                // Если список не пуст, сохраняем имя категории
                if let firstProduct = sortedGoodsList.first {
                    self.categoryName = firstProduct.category.name
                }
            }
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
