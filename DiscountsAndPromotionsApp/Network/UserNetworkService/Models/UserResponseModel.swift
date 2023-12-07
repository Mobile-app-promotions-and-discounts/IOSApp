import Foundation

struct UserResponseModel: Codable {
    let phone: String?
    let role: String
    let foto: String?
    let firstName: String?
    let lastName: String?
    let id: Int
    let username: String

    enum CodingKeys: String, CodingKey {
        case phone
        case role
        case foto
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case id
    }
}

typealias UsersResponseModel = [UserResponseModel]
