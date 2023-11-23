import UIKit

struct CategoryCellUIModel {
    let image: String?
    let name: String
    let description: String
    let lowerPrice: Double?
    let higherPrice: Double?

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product) {
        self.image = product.image?.mainImage
        self.name = product.name
        self.description = product.description

        let minMaxOffers = product.findMinMaxOffers()

        self.lowerPrice = minMaxOffers.minOffer?.price
        self.higherPrice = minMaxOffers.maxOffer?.price
    }
}
