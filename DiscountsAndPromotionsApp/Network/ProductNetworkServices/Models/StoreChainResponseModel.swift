import Foundation

struct StoreChainResponseModel: Codable {
    let id: Int
    let name: String
    let logo: String?
    let website: String?

    func convert() -> ChainStore {
        return ChainStore(id: id,
                          name: name,
                          logo: logo,
                          website: website)
    }
}

typealias StoreChainsResponseModel = [StoreChainResponseModel]
