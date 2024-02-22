import Foundation

struct MyProductReview: Codable {
    let text: String
    let score: Int
}

struct ProductReviewModel: Codable {
    let user: String?
    let text: String
    let score: Int
    let priductID: String?
    let productName: String?

    enum CodingKeys: String, CodingKey {
        case user, text, score
        case priductID = "product_id"
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
