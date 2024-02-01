import Foundation

struct OfferUIModel {
    let initialPrice: Double
    let discountPrice: Double
    let discount: Discount?
    let store: Store

    init (offer: Offer) {
        self.initialPrice = offer.initialPrice
        self.discountPrice = offer.price
        self.discount = offer.discount
        self.store = offer.store
    }
}
