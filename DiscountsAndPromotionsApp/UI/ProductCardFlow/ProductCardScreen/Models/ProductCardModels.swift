import UIKit

// Определение enum для типов ячеек с ассоциированными значениями для данных конфигурации
enum ProductCardCellType {
    case image(ProductImageUIModel)
    case name(ProductTitleUIModel)

}

// Модели данных для каждого типа ячейки
struct ProductImageUIModel {
    let imageURL: String?

    init(product: Product) {
        self.imageURL = product.image?.mainImage
    }
}

struct ProductTitleUIModel {
    let name: String

    init(product: Product) {
        self.name = product.name
    }
}

struct ProductReviewsInfoUIModel {}
