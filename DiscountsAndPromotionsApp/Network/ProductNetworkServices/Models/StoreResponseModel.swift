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

    func convert() -> Store {
        let location = location?.convert() ?? StoreLocation(region: "",
                                                            city: "",
                                                            street: "",
                                                            building: "",
                                                            postalIndex: 000000)

        return Store(id: self.id,
                     name: self.name ?? "",
                     image: nil,
                     location: location,
                     chainStore: chainStore?.convert())
    }
}

typealias StoresResponseModel = [StoreResponseModel]
