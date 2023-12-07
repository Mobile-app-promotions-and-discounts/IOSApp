import UIKit
import Combine

protocol PriceInfoViewViewModelProtocol {
    var pricePublisher: AnyPublisher<Double, Never> { get }
    var discountPricePublisher: AnyPublisher<Double, Never> { get }
    var addToFavorites: PassthroughSubject<Void, Never> { get }
    func updatePrice(_ price: Double)
    func updateDiscountPrice(_ discountPrice: Double)

}

class PriceInfoViewViewModel: PriceInfoViewViewModelProtocol {
    @Published private (set) var price: Double = 0.0
    @Published private (set) var discountPrice: Double = 0.0
    var addToFavorites = PassthroughSubject<Void, Never>()

    // Предоставляем @Published свойства как паблишеры
    var pricePublisher: AnyPublisher<Double, Never> {
        $price.eraseToAnyPublisher()
    }
    var discountPricePublisher: AnyPublisher<Double, Never> {
        $discountPrice.eraseToAnyPublisher()
    }

    func updatePrice(_ price: Double) {
        self.price = price
    }

    func updateDiscountPrice(_ discountPrice: Double) {
        self.discountPrice = discountPrice
    }
}
