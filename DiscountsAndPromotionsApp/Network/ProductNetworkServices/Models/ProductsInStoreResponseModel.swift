import Foundation

struct StoreElementResponseModel: Codable {
   let id: Int
   let discount: DiscountResponseModel?
   let store: StoreResponseModel?
   let price: String?
}

typealias ProductsInStore = [StoreElementResponseModel]
