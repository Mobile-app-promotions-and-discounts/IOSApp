import UIKit

struct ProductCellUIModel {
    let id: Int
    let image: String?
    let name: String
    let formattedPriceRange: String
    let formattedDiscount: String
    var isFavorite: Bool

    // Инициализатор для преобразования Product в UI модель для отображения
    init(product: Product) {
        self.id = product.id
        self.image = product.image?.mainImage
        self.name = product.name
        self.isFavorite = product.isFavorite

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
        let discoutUnitString: String = product.findMaxCurrentDiscount()?.discountUnit ?? ""
        let discoutUnit: Discount.DiscountUnit? = Discount.DiscountUnit(rawValue: discoutUnitString)
        var discoutUnitFormattedString = ""
        if let discoutUnit {
            discoutUnitFormattedString = discoutUnit.formattedString()
        }

        let discountValue = product.findMaxCurrentDiscount()?.discountRate ?? 0
        self.formattedDiscount = discountValue > 0 ? "До -\(discountValue)\(discoutUnitFormattedString)" : ""
    }
}
