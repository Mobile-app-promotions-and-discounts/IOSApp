import Foundation

struct CityModel {
    let name: String
    let country: String

    init(name: String, country: String) {
        self.name = name
        self.country = country
    }

    init(responceModel: CityResponseModel) {
        self.name = responceModel.name
        self.country = responceModel.country
    }
}
