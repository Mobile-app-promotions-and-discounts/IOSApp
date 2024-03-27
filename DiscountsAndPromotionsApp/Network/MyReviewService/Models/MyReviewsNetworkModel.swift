import Foundation

struct MyReviewsNetModel: Codable {
    let count: Int
    let next, previous: String?
    var results: [MyReviewNetModel]
}
