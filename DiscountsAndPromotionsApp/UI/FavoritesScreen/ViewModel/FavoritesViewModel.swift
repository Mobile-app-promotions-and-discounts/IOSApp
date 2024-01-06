import Foundation
import Combine

final class FavoritesViewModel: FavoritesViewModelProtocol {
    private (set) var favoriteProductsUpdate = PassthroughSubject<[Product], Never>()
    private (set) var viewState = CurrentValueSubject<ViewState, Never>(.loading)

    private var favoriteProducts = [Product]() {
        didSet {
            favoriteProductsUpdate.send(favoriteProducts)
            viewState.value = favoriteProducts.isEmpty ? .empty : .dataPresent
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
        return favoriteProducts.count
    }

    func getProduct(for index: Int) -> ProductCellUIModel {
        let product = favoriteProducts[index]
        return convertModels(for: product)
    }

    func getProductById(_ id: Int) -> Product? {
        return favoriteProducts.first { $0.id == id }
    }

    func likeButtonTapped(for productID: Int) {
        guard let productIndex = favoriteProducts.firstIndex(where: { $0.id == productID }) else {
            ErrorHandler.handle(error: .customError("Продукт с ID \(productID) не найден"))
            return
        }

        let product = favoriteProducts[productIndex]
        if profileService.isFavorite(product) {
            profileService.removeFavorite(product)
        } else {
            profileService.addFavorite(product)
        }
    }

    func getTitleForHeader() -> String {
        return NSLocalizedString("Favorites", tableName: "FavoritesFlow", comment: "")
    }

    private func setupBindings() {
        profileService.updatedProfile
            .sink { [weak self] updatedProfile in
                guard let self = self else { return }
                self.favoriteProducts = Array(updatedProfile.favoritesProducts)
            }
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
