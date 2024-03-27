import Foundation

struct MyReviewNetModel: Codable {
    let id, productID: Int
    let productName: String
    let user: String
    let text: String
    let score: Int
    let pubDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case productName = "product_name"
        case user, text, score
        case pubDate = "pub_date"
    }
}
