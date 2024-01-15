import Foundation

struct UserShotResponseModel: Codable {
    let id: Int
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, password
    }
}
