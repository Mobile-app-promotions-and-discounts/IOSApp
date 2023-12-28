import Foundation

struct PaginatedProductResponseModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: ProductGroupResponseModel
}

struct ProductResponseModel: Codable {
    let id: Int
    let name: String
    let rating: Int?
    let category: CategoryResponseModel
    let description: String?
    let mainImage: String?
    let barcode: String
    let stores: ProductsInStore?
    let isFavorited: Bool
    let images: ImageListResponseModel

    enum CodingKeys: String, CodingKey {
        case id, name, rating, category, description, barcode, stores, images
        case isFavorited = "is_favorited"
        case mainImage = "main_image"
    }

    func convertToProductModel() -> Product {
        let category = Category(id: self.category.id,
                                name: self.category.name,
                                image: "")
        let additionalImges: [String] = self.images.map { $0.image }
        let image = ProductImage(mainImage: self.mainImage,
                                 additionalPhoto: additionalImges)

        return Product(id: self.id,
                       barcode: self.barcode,
                       name: self.name,
                       description: self.description ?? "",
                       category: category,
                       image: image,
                       rating: nil,
                       offers: [])
    }
}

typealias ProductGroupResponseModel = [ProductResponseModel]

struct ImageResponseModel: Codable {
    let image: String
}

typealias ImageListResponseModel = [ImageResponseModel]
