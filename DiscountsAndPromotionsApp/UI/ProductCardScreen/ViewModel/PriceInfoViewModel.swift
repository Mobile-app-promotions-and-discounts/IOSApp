import UIKit
import Combine

class PriceInfoViewViewModel {
    @Published var price: Double = 0.0
    @Published var discountPrice = 0.0
    var addToFavorites = PassthroughSubject<Void, Never>()
}
