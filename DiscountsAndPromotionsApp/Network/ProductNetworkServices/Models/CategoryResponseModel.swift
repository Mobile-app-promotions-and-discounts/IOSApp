import Foundation

struct CategoryResponseModel: Codable {
    let id: Int
    let name: String
}

typealias CategoriesResponseModel = [CategoryResponseModel]
