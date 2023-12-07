import Foundation

struct StoreResponseModel: Codable {
   let id: Int?
   let location: LocationResponseModel?
   let chainStore: StoreChainResponseModel?
   let name: String?

   enum CodingKeys: String, CodingKey {
       case id, location
       case chainStore = "chain_store"
       case name
   }
}

struct StoreElementResponseModel: Codable {
   let id: Int?
   let discount: Discount?
   let store: StoreResponseModel?
   let price: String?
}

struct LocationResponseModel: Codable {
   let id: Int
   let region, city, street, building: String?
}

struct DiscountResponseModel: Codable {
   let discountRate: Int
   let discountUnit, discountStart, discountEnd: String?
   let discountCard: Bool

   enum CodingKeys: String, CodingKey {
       case discountRate = "discount_rate"
       case discountUnit = "discount_unit"
       case discountStart = "discount_start"
       case discountEnd = "discount_end"
       case discountCard = "discount_card"
   }
}

struct StoreChainResponseModel: Codable {

}

typealias StoreChainsResponseModel = [StoreChainResponseModel]
