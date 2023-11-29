import Foundation
import Combine

final class FavoritesViewModel: FavoritesViewModelProtocol {
    private (set) var favoriteProductsUpdate = PassthroughSubject<[Product], Never>()

    private var favoriteProducts = [Product]() {
        didSet {
            favoriteProductsUpdate.send(favoriteProducts)
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

    func likeButtonTapped(for productID: UUID) {
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

    private func setupBindings() {
        profileService.updatedProfile
            .sink { [weak self] updatedProfile in
                guard let self = self else { return }
                self.favoriteProducts = updatedProfile.favoritesProducts
            }
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> ProductCellUIModel {
        let isFavorite = profileService.isFavorite(product)
        return ProductCellUIModel(product: product, isFavorite: isFavorite)
    }
}
