import Foundation

struct StoreResponseModel: Codable {
   let id: Int
   let location: LocationResponseModel?
   let chainStore: StoreChainResponseModel?
   let name: String?

   enum CodingKeys: String, CodingKey {
       case id, location
       case chainStore = "chain_store"
       case name
   }
}
