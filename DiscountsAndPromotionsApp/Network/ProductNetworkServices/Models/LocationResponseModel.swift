import Foundation

struct LocationResponseModel: Codable {
   let id: Int
   let region, city, street, building: String?

    func convert() -> StoreLocation {
        return StoreLocation(region: region ?? "",
                             city: city ?? "",
                             street: street ?? "",
                             building: building ?? "",
                             postalIndex: 0)
    }
}
