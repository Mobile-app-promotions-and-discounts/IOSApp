import Foundation

struct MyProductReview: Codable {
    let id: Int?
    let text: String
    let score: Int

    init(id: Int? = nil, text: String, score: Int) {
        self.id = id
        self.text = text
        self.score = score
    }
}

struct ProductReviewModel: Codable {
    let id: Int
    let productID: Int
    let productName: String?
    let user: String
    let text: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case user, text, score, id
        case productID = "product_id"
        case productName = "product_name"
    }
}

typealias ProductReviews = [ProductReviewModel]

struct ReviewResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: ProductReviews
}
