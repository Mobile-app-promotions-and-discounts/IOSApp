import Foundation

struct StoreChainResponseModel: Codable {
    let id: Int
    let name: String?

    func convert() -> ChainStore {
        return ChainStore(id: id,
                          name: name ?? "")
    }
}

typealias StoreChainsResponseModel = [StoreChainResponseModel]
