import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let barcode: String
    let name: String
    let description: String
    let category: Category
    let image: ProductImage?
    let rating: Double?
    let offers: [Offer] // Предложения от разных магазинов
    let isFavorite: Bool

    init(id: Int = 0,
         barcode: String,
         name: String,
         description: String,
         category: Category,
         image: ProductImage?,
         rating: Double?,
         offers: [Offer],
         isFavorite: Bool = false) {
        self.id = id
        self.barcode = barcode
        self.name = name
        self.description = description
        self.category = category
        self.image = image
        self.rating = rating
        self.offers = offers
        self.isFavorite = isFavorite
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let image: String?
}

struct Offer: Codable, Hashable {
    let id: Int
    let price: Double
    let initialPrice: Double
    let discount: Discount?
    let store: Store

    init(id: Int = 0,
         price: Double,
         initialPrice: Double,
         discount: Discount?,
         store: Store) {
        self.id = id
        self.price = price
        self.initialPrice = initialPrice
        self.discount = discount
        self.store = store
    }

    static func == (lhs: Offer, rhs: Offer) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ProductImage: Codable, Hashable {
    let mainImage: String?
    let additionalPhoto: [String]?
}

struct Store: Codable, Hashable {
    let id: Int
    let name: String
    let image: StoreImage?
    let location: StoreLocation
    let chainStore: ChainStore?

    init(id: Int = 0,
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

    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
}

struct StoreImage: Codable, Hashable {
    let mainImage: String?
    let logoImage: String?
}

struct StoreLocation: Codable, Hashable {
    let region: String
    let city: String
    let street: String
    let building: String
    let postalIndex: Int
}

struct ChainStore: Codable, Hashable {
    let id: Int
    let name: String
    let logo: String?
    let website: String?
}

struct Discount: Codable, Hashable {
    let discountRate: Int
    let discountUnit: String
    let discountRating: Int
    let discountStart: Date
    let discountEnd: Date
    let discountCard: Bool

    enum DiscountUnit: String {
        case percent = "%"
        case ruble = "RUB"

        func formattedString() -> String {
            switch self {
            case .ruble:
                return "₽"
            case .percent:
                return "%"
            }
        }
    }

    func formattedDiscountString() -> String {
        var formattedDiscountString = ""
        if let unit = DiscountUnit(rawValue: self.discountUnit) {
            switch unit {
            case .percent:
                formattedDiscountString = "%"
            case .ruble:
                formattedDiscountString = "₽"
            }
        }
        return "-\(self.discountRate)" + formattedDiscountString
    }
}

extension Product {
    // Находим максимальное и минимальное предложение по цене
    func findMinMaxOffers() -> (minOffer: Offer?, maxOffer: Offer?) {
        guard !offers.isEmpty else { return (nil, nil) }

        let minOffer = offers.min(by: { $0.price < $1.price })
        let maxOffer = offers.max(by: { $0.price < $1.price })

        return (minOffer, maxOffer)
    }

    func findMinMaxInitialOffers() -> (minOffer: Offer?, maxOffer: Offer?) {
        guard !offers.isEmpty else { return (nil, nil) }

        let minOffer = offers.min(by: { $0.initialPrice < $1.initialPrice })
        let maxOffer = offers.max(by: { $0.initialPrice < $1.initialPrice })

        return (minOffer, maxOffer)
    }

    // Функция для поиска максимальной текущей скидки на продукт
    func findMaxCurrentDiscount() -> Discount? {
        // Текущая дата для сравнения с датами скидок
        let currentDate = Date()

        // Фильтруем предложения, оставляем только те, где есть скидка и она действительна
        let validDiscounts = offers.compactMap { offer -> Discount? in
            guard let discount = offer.discount,
                  currentDate >= discount.discountStart,
                  currentDate <= discount.discountEnd else {
                return nil
            }
            return discount
        }

        // Ищем предложение с максимальной скидкой
        return validDiscounts.max(by: { $0.discountRate < $1.discountRate })
    }
}
