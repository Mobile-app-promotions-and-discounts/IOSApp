import UIKit
import Combine

protocol PriceInfoViewViewModelProtocol {
    var pricePublisher: AnyPublisher<Int, Never> { get }
    var discountPricePublisher: AnyPublisher<Int, Never> { get }
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
    var addToFavorites = PassthroughSubject<Void, Never>()
    private let profileService: ProfileServiceProtocol
    private var product: Product

    init(profileService: ProfileServiceProtocol, product: Product) {
        self.profileService = profileService
        self.product = product
    }

    var isFavorite: Bool {
        profileService.isFavorite(product)
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

    func updatePrice(_ price: Int) {
            self.price = price
    }

    func updateDiscountPrice(_ discountPrice: Int) {
            self.discountPrice = discountPrice
    }

    func toggleFavorite() {
        if profileService.isFavorite(product) {
            profileService.removeFavorite(product)
        } else {
            profileService.addFavorite(product)
        }
    }

}
