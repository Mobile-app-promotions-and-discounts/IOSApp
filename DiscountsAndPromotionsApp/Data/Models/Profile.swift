import UIKit

struct Profile: Codable {
    let id: String?
    let avatar: String
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String
    let birthdate: String?
    let gender: Bool?
    let favoritesProducts: Set<Product>
}
