import UIKit
import Combine

protocol PriceInfoViewViewModelProtocol {
    var pricePublisher: AnyPublisher<Int, Never> { get }
    var discountPricePublisher: AnyPublisher<Int, Never> { get }
    var addToFavorites: PassthroughSubject<Void, Never> { get }
    var isFavorite: Bool { get }

    func updatePrice(_ price: Int)
    func updateDiscountPrice(_ discountPrice: Int)
    func toggleFavorite()
}

class PriceInfoViewViewModel: PriceInfoViewViewModelProtocol {
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
        $price.eraseToAnyPublisher()
    }
    var discountPricePublisher: AnyPublisher<Int, Never> {
        $discountPrice.eraseToAnyPublisher()
    }

    func updatePrice(_ price: Int) {
        DispatchQueue.main.async {
            print("Updating price to \(price)")
            self.price = price
        }
    }

    func updateDiscountPrice(_ discountPrice: Int) {
        DispatchQueue.main.async {
            print("Updating discount price to \(discountPrice)")
            self.discountPrice = discountPrice
        }
    }

    func toggleFavorite() {
        if isFavorite {
            profileService.removeFavorite(product)
        } else {
            profileService.addFavorite(product)
        }
    }

}
