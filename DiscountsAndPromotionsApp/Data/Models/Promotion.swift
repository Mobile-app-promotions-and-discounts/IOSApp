import UIKit

struct Promotion: Codable {
    let id: UUID
    let text: String
    let store: Store
    let category: Category
    let discount: Discount

    init(id: UUID = UUID(), text: String, store: Store, category: Category, discount: Discount) {
        self.id = id
        self.text = text
        self.store = store
        self.category = category
        self.discount = discount
    }
}

// Конвертация модели данных об акциях в модель для отображения в UI
extension Promotion {
    func toUIModel(visualsService: PromotionVisualsService) -> PromotionUIModel? {
        guard let visualAttributes = visualsService.visualAttributesForCategory(self.category) else {
            return nil
        }

        let storeLogo = UIImage(named: store.image?.logoImage ?? "") ?? UIImage()
        let promoText = self.text
        let promotionImage = visualAttributes.image
        let gradientLayer = visualAttributes.gradient

        return PromotionUIModel(
            storeLogo: storeLogo,
            promoText: promoText,
            promotionImage: promotionImage,
            gradientLayer: gradientLayer
        )
    }
}
