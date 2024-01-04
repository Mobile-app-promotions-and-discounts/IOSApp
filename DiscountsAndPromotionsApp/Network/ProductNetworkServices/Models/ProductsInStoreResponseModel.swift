import Foundation

struct StoreElementResponseModel: Codable {
    let id: Int
    let discount: DiscountResponseModel?
    let store: StoreResponseModel?
    let initialPrice: String
    let promoPrice: String

    enum CodingKeys: String, CodingKey {
        case id, discount, store
        case initialPrice = "initial_price"
        case promoPrice = "promo_price"
    }
}

typealias ProductsInStore = [StoreElementResponseModel]
