import Foundation

struct StoreElementResponseModel: Codable {
   let id: Int
   let discount: DiscountResponseModel?
 //  let store: StoreResponseModel?
   let price: String?
}

typealias ProductsInStore = [StoreElementResponseModel]

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

struct LocationResponseModel: Codable {
   let id: Int
   let region, city, street, building: String?
}

struct StoreChainResponseModel: Codable {

}

typealias StoreChainsResponseModel = [StoreChainResponseModel]
