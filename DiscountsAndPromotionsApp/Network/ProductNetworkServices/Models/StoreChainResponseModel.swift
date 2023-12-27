import Foundation

struct StoreChainResponseModel: Codable {
    let id: Int
    let name: String?
}

typealias StoreChainsResponseModel = [StoreChainResponseModel]
