import UIKit

enum ProductCardSections: Int, CaseIterable {
    case imagesAndReviews
    case storeOffers
}

// Определение enum для типов ячеек с ассоциированными значениями для данных конфигурации
enum ProductCardCellType {
    case image(ProductImageUIModel)
    case name(ProductTitleUIModel)
    case reviewsInfo(ProductReviewsInfoUIModel)
    case storeOffers
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
}

struct ProductReviewsInfoUIModel {
    let rating: Double
    let reviewsCount: Int

    init(product: Product, reviewsCount: Int) {
        self.rating = product.rating ?? 0
        self.reviewsCount = reviewsCount
    }
}

struct ProductStoreOfferUIModel {
    let storeLogo: String?
    let storeName: String
    let storeAdress: String
    let finalPrice: Double
    let discounValue: String?
    let oldPrice: Double
    let storeURLadress: String?

    init(offer: Offer) {
        self.storeLogo = offer.store.chainStore?.logo
        self.storeName = offer.store.name
        self.storeAdress = offer.store.location.street
        self.finalPrice = offer.price
        self.discounValue = offer.discount?.formattedDiscountString()
        self.oldPrice = offer.initialPrice
        self.storeURLadress = offer.store.chainStore?.website
    }
}
