import UIKit
import Combine

protocol PriceInfoViewViewModelProtocol {
    var pricePublisher: AnyPublisher<Int, Never> { get }
    var discountPricePublisher: AnyPublisher<Int, Never> { get }
    var favoritesUpdate: AnyPublisher<Bool, Never> { get }
    var addToFavorites: PassthroughSubject<Void, Never> { get }
    var isFavorite: Bool { get }
    var price: Int { get }
    var discountPrice: Int { get }

    func updatePrice(_ price: Int)
    func updateDiscountPrice(_ discountPrice: Int)
    func toggleFavorite()
}

final class PriceInfoViewViewModel: PriceInfoViewViewModelProtocol {
    @Published private (set) var price: Int = 0
    @Published private (set) var discountPrice: Int = 0
    @Published private (set) var isFavorite = false
    var addToFavorites = PassthroughSubject<Void, Never>()
    private let productService: ProductNetworkServiceProtocol
    private var product: Product

    private var cancellables = Set<AnyCancellable>()

    init(product: Product, productService: ProductNetworkServiceProtocol) {
        self.product = product
        self.isFavorite = product.isFavorite
        self.productService = productService

        bindFavoritesStatus()
    }

    // Предоставляем @Published свойства как паблишеры
    var pricePublisher: AnyPublisher<Int, Never> {
        $price
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    var discountPricePublisher: AnyPublisher<Int, Never> {
        $discountPrice
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var favoritesUpdate: AnyPublisher<Bool, Never> {
        $isFavorite
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func updatePrice(_ price: Int) {
            self.price = price
    }

    func updateDiscountPrice(_ discountPrice: Int) {
            self.discountPrice = discountPrice
    }

    private func bindFavoritesStatus() {
        productService.isFavoriteUpdate
            .sink { [weak self] _, isFavorite in
                self?.isFavorite = isFavorite
            }
            .store(in: &cancellables)
    }

    func toggleFavorite() {
        if isFavorite {
            productService.removeFromFavorites(productID: product.id)
        } else {
            productService.addToFavorites(productID: product.id)
        }
    }

}
