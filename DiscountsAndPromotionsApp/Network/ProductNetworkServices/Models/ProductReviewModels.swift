import Foundation

struct MyProductReview: Codable {
    let text: String
    let score: Int
}

struct ProductReviewModel: Codable {
    let user: String?
    let text: String
    let score: Int
}

typealias ProductReviews = [ProductReviewModel]

struct ReviewResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: ProductReviews
}
