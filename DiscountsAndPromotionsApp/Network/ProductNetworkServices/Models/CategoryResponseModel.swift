import Foundation

struct CategoryResponseModel: Codable {
    let id: Int
    let name: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case name = "get_name_display"
    }
}

typealias CategoriesResponseModel = [CategoryResponseModel]
