import Foundation

struct ProductReviewModel: Codable {
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
