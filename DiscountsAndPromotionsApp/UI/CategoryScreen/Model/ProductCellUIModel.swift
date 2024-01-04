import UIKit

struct ProductCellUIModel {
    let id: Int
    let image: String?
    let name: String
    let description: String
    let formattedPriceRange: String
    let formattedDiscount: String
    var isFavorite: Bool

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product, isFavorite: Bool) {
        self.id = product.id
        self.image = product.image?.mainImage
        self.name = product.name
        self.description = product.description
        self.isFavorite = isFavorite

        // Форматирование диапазона цен
        if let lowerPrice = product.findMinMaxOffers().minOffer?.price,
           let higherPrice = product.findMinMaxOffers().maxOffer?.price {
            if lowerPrice == higherPrice {
                self.formattedPriceRange = "\(lowerPrice.customFormatted()) ₽"
            } else {
                self.formattedPriceRange = "\(lowerPrice.customFormatted())–\(higherPrice.customFormatted()) ₽"
            }
        } else {
            self.formattedPriceRange = "Цена не указана"
        }

        // Форматирование скидки
        let discountValue = product.findMaxCurrentDiscount()?.discountRate ?? 0
        self.formattedDiscount = discountValue > 0 ? "До -\(discountValue)%" : "До - 30%"
    }
}
