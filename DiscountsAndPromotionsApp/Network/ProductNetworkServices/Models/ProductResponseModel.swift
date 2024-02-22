import Foundation

struct PaginatedProductResponseModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: ProductGroupResponseModel
}

struct ProductResponseModel: Codable {
    let id: Int
    let name: String
    let rating: Float?
    let category: CategoryResponseModel
    let description: String?
    let mainImage: String?
    let barcode: String
    let stores: ProductsInStore?
    let isFavorited: Bool
    let images: ImageListResponseModel
    let myReview: String?

    enum CodingKeys: String, CodingKey {
        case id, name, rating, category, description, barcode, stores, images
        case isFavorited = "is_favorited"
        case mainImage = "main_image"
        case myReview = "my_review"
    }

    func convertToProductModel() -> Product {
        let category = Category(id: self.category.id,
                                name: self.category.name,
                                image: self.category.image ?? "")
        let additionalImges: [String] = self.images.map { $0.image }
        let image = ProductImage(mainImage: self.mainImage,
                                 additionalPhoto: additionalImges)

        var offers: [Offer] = []

        var modelRating: Double?
        if let responseRating = self.rating { modelRating = Double(responseRating) }

        if let originalOffers: [StoreElementResponseModel] = self.stores {
            for offer in originalOffers {
                if let price = Double(offer.promoPrice),
                   let initialPrice = Double(offer.initialPrice),
                   let store = offer.store {
                    offers.append(Offer(id: offer.id,
                                        price: price / 100,
                                        initialPrice: initialPrice / 100,
                                        discount: offer.discount?.convert(),
                                        store: store.convert()))
                }
            }
        }

        return Product(id: self.id,
                       barcode: self.barcode,
                       name: self.name,
                       description: self.description ?? "",
                       category: category,
                       image: image,
                       rating: modelRating,
                       offers: offers,
                       isFavorite: isFavorited,
                       myReview: myReview)
    }
}

typealias ProductGroupResponseModel = [ProductResponseModel]

struct ImageResponseModel: Codable {
    let image: String
}

typealias ImageListResponseModel = [ImageResponseModel]
