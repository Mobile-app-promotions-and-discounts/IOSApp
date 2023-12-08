import UIKit
import Combine

protocol PriceInfoViewViewModelProtocol {
    var pricePublisher: AnyPublisher<Double, Never> { get }
    var discountPricePublisher: AnyPublisher<Double, Never> { get }
    var addToFavorites: PassthroughSubject<Void, Never> { get }
    var isFavorite: Bool { get }

    func updatePrice(_ price: Double)
    func updateDiscountPrice(_ discountPrice: Double)
    func toggleFavorite()
}

class PriceInfoViewViewModel: PriceInfoViewViewModelProtocol {
    @Published private (set) var price: Double = 0.0
    @Published private (set) var discountPrice: Double = 0.0
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
    var pricePublisher: AnyPublisher<Double, Never> {
        $price.eraseToAnyPublisher()
    }
    var discountPricePublisher: AnyPublisher<Double, Never> {
        $discountPrice.eraseToAnyPublisher()
    }

    func updatePrice(_ price: Double) {
        DispatchQueue.main.async {
            print("Updating price to \(price)")
            self.price = price
        }
    }

    func updateDiscountPrice(_ discountPrice: Double) {
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
