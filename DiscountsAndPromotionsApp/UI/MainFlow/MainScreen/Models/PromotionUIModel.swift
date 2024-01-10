import UIKit

struct PromotionUIModel {
    let productImage: String?
    let discount: String
    let price: String
    let gradientAccentColor: UIColor
    let gradientLayer: CAGradientLayer

    // Инициализатор для преобразования Product в UI модель для акции
    init(product: Product, visualsService: PromotionVisualsService) {
        self.productImage = product.image?.mainImage
        
        /// КОД ниже дублируется с ProductCellUIModel - если команда решит что акции будут именно такими - нужен рефакторинг

        // Форматирование диапазона цен
        if let lowerPrice = product.findMinMaxOffers().minOffer?.price,
           let higherPrice = product.findMinMaxOffers().maxOffer?.price {
            if lowerPrice == higherPrice {
                self.price = "\(lowerPrice.customFormatted()) ₽"
            } else {
                self.price = "\(lowerPrice.customFormatted())–\(higherPrice.customFormatted()) ₽"
            }
        } else {
            self.price = "Цена не указана"
        }

        // Форматирование скидки
        let discoutUnitString: String = product.findMaxCurrentDiscount()?.discountUnit ?? ""
        let discoutUnit: Discount.DiscountUnit? = Discount.DiscountUnit(rawValue: discoutUnitString)
        var discoutUnitFormattedString = ""
        if let discoutUnit {
            discoutUnitFormattedString = discoutUnit.formattedString()
        }

        let discountValue = product.findMaxCurrentDiscount()?.discountRate ?? 0
        self.discount = discountValue > 0 ? "До -\(discountValue)\(discoutUnitFormattedString)" : ""

        if let visualAttributes = visualsService.visualAttributesForCategory(product.category) {
            let accentColor: UIColor = visualAttributes.accentColor
            let gradientLayer = visualAttributes.gradient

            self.gradientAccentColor = accentColor
            self.gradientLayer = gradientLayer
        } else {
            self.gradientAccentColor = .clear
            self.gradientLayer = CAGradientLayer()
            ErrorHandler.handle(error: .customError("Ошибка настройки градиента акции по товару"))
        }
    }
}
