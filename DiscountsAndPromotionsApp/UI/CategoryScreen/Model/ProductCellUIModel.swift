import UIKit

struct ProductCellUIModel {
    let id: UUID
    let image: UIImage?
    let name: String
    let description: String
    let formattedPriceRange: String
    let formattedDiscount: String
    var isFavorite: Bool

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product, isFavorite: Bool) {
        self.id = product.id

        if let image = product.image?.mainImage {
            self.image = UIImage(named: image)
        } else {
            self.image = nil
        }

        self.name = product.name
        self.description = product.description
        self.isFavorite = isFavorite

        // Форматирование диапазона цен
        if let lowerPrice = product.findMinMaxOffers().minOffer?.price,
           let higherPrice = product.findMinMaxOffers().maxOffer?.price {
            self.formattedPriceRange = "\(lowerPrice.customFormatted())–\(higherPrice.customFormatted()) ₽"
        } else {
            self.formattedPriceRange = "Цена не указана"
        }

        // Форматирование скидки
        let discountValue = product.findMaxCurrentDiscount()?.discountRate ?? 0
        self.formattedDiscount = discountValue > 0 ? "До -\(discountValue)%" : "До - 30%"
    }
}
