import Foundation

struct ProductResponseModel: Codable {
    let id: Int
    let name: String
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

    func convertToProductModel() -> Product {
        return Product(id: UUID(),
                       barcode: self.barcode,
                       name: self.name,
                       description: self.description ?? "",
                       category: Category(name: self.category?.name ?? "", image: ""),
                       image: nil,
                       rating: nil,
                       offers: [])
    }
}

typealias ProductGroupResponseModel = [ProductResponseModel]
