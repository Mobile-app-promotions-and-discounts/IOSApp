import Foundation

struct Product: Codable {
    let id: UUID
    let barcode: String
    let name: String
    let description: String
    let category: Category
    let image: ProductImage?
    let rating: Double?
    let offers: [Offer] // Предложения от разных магазинов

    init(id: UUID = UUID(),
         barcode: String,
         name: String,
         description: String,
         category: Category,
         image: ProductImage?,
         rating: Double?,
         offers: [Offer]) {
        self.id = id
        self.barcode = barcode
        self.name = name
        self.description = description
        self.category = category
        self.image = image
        self.rating = rating
        self.offers = offers
    }
}

struct Category: Codable {
    let id: UUID
    let name: String

    init(id: UUID = UUID(),
         name: String) {
        self.id = id
        self.name = name
    }
}

struct Offer: Codable {
    let id: UUID
    let price: Double
    let discount: Discount?
    let store: Store

    init(id: UUID = UUID(),
         price: Double,
         discount: Discount?,
         store: Store) {
        self.id = id
        self.price = price
        self.discount = discount
        self.store = store
    }
}

struct ProductImage: Codable {
    let mainImage: String
    let additionalPhoto: [String]
}

struct Store: Codable {
    let id: UUID
    let name: String
    let image: StoreImage?
    let location: StoreLocation
    let chainStore: ChainStore?

    init(id: UUID = UUID(),
         name: String,
         image: StoreImage?,
         location: StoreLocation,
         chainStore: ChainStore?) {
        self.id = id
        self.name = name
        self.image = image
        self.location = location
        self.chainStore = chainStore
    }
}

struct StoreImage: Codable {
    let mainImage: String
}

struct StoreLocation: Codable {
    let region: String
    let city: String
    let street: String
    let building: Int
    let postalIndex: Int
}

struct ChainStore: Codable {
    let id: UUID
    let name: String
}

struct Discount: Codable {
    let discountRate: Int
    let discountUnit: Int
    let discountRating: Int
    let discountStart: Date
    let discountEnd: Date
    let discountCard: Bool
}

extension Product {
    // Находим максимальное и минимальное предложение по цене
    func findMinMaxOffers() -> (minOffer: Offer?, maxOffer: Offer?) {
        guard !offers.isEmpty else { return (nil, nil) }

        var minOffer: Offer = offers[0]
        var maxOffer: Offer = offers[0]

        for offer in offers {
            if offer.price < minOffer.price {
                minOffer = offer
            }
            if offer.price > maxOffer.price {
                maxOffer = offer
            }
        }

        return (minOffer, maxOffer)
    }
}
