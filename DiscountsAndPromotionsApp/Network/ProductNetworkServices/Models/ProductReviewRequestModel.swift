import Foundation

struct ProductReviewModel: Codable {
    let text: String
    let score: Int
}

typealias ProductReviews = [ProductReviewModel]
