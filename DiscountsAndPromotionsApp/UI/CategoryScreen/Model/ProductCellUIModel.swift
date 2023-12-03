import UIKit

struct ProductCellUIModel {
    let id: UUID
    let image: String?
    let name: String
    let description: String
    let lowerPrice: Double?
    let higherPrice: Double?
    var isFavorite: Bool

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product, isFavorite: Bool) {
        self.id = product.id
        self.image = product.image?.mainImage
        self.name = product.name
        self.description = product.description

        let minMaxOffers = product.findMinMaxOffers()

        self.lowerPrice = minMaxOffers.minOffer?.price
        self.higherPrice = minMaxOffers.maxOffer?.price
        self.isFavorite = isFavorite
    }
}
