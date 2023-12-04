import Foundation
import Combine

final class CategoryViewModel: CategoryViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()

    private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    private var dataService: DataServiceProtocol
    private var profileService: ProfileServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol, profileService: ProfileServiceProtocol) {
        self.dataService = dataService
        self.profileService = profileService
        setupBindings()
    }

    func numberOfItems() -> Int {
        return products.count
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    func likeButtonTapped(for productID: UUID) {
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
        dataService.actualProductsList
            .sink { [weak self] productsList in
                guard let self = self else { return }
                self.products = productsList
            }
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
