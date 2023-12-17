import Foundation

struct ProductResponseModel: Codable {
    let id: Int
    let name: String?
    let rating: Int?
    let category: CategoryResponseModel?
    let description: String?
    let mainImage: String?
    let barcode: String
    let stores: ProductsInStore?
    let isFavorited: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, rating, category, description, barcode, stores
        case isFavorited = "is_favorited"
        case mainImage = "main_image"
    }
}

typealias ProductGroupResponseModel = [ProductResponseModel]
