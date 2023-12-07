import Foundation

struct ProductResponseModel: Codable {
    let name: String
    let rating: Int
    let category: CategoryResponseModel
    let description: String
}

// Изображение сервер пока отдает как Int, его я не включал.
// также позже добавлю список магазинов и скидок

typealias ProductGroupResponseModel = [ProductResponseModel]
