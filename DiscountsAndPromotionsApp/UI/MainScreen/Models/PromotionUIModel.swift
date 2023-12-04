import UIKit

struct PromotionUIModel {
    let image: String?
    let name: String
    let description: String
    let product: Product

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product) {
        self.image = product.image?.mainImage
        self.name = product.name
        self.description = product.description
        self.product = product
    }
}
