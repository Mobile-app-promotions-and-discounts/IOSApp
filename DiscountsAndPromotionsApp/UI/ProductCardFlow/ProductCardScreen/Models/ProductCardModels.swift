import UIKit

enum ProductCardSections: Int, CaseIterable {
    case imagesAndReviews
}

// Определение enum для типов ячеек с ассоциированными значениями для данных конфигурации
enum ProductCardCellType {
    case image(ProductImageUIModel)
    case name(ProductTitleUIModel)
    case reviewsInfo(ProductReviewsInfoUIModel)
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

struct ProductReviewsInfoUIModel {
    let rating: Double
    let reviewsCount: Int

    init(product: Product, reviewsCount: Int) {
        self.rating = product.rating ?? 0
        self.reviewsCount = reviewsCount
    }
}
