import Foundation

struct ProductResponseModel: Codable {
    let id: Int
    let name: String?
    let rating: Int?
    let category: CategoryResponseModel?
    let description: String?
    let image: Int?
//    нужна правка модели
//    let stores: [StoreElementResponseModel]?
    let isFavorited: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, rating, category, description, image
        case isFavorited = "is_favorited"
    }
}

typealias ProductGroupResponseModel = [ProductResponseModel]
