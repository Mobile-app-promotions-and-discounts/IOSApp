import Foundation

struct UserResponseModel: Codable {
    let phone: String?
    let role: String
    let photo: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let dateOfBirth: String?
    let id: Int
    let username: String

    enum CodingKeys: String, CodingKey {
        case phone
        case role
        case photo
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case dateOfBirth = "date_of_birth"
        case username
        case id
    }

    static let emptyModel = UserResponseModel(phone: "",
                                              role: "",
                                              photo: "",
                                              firstName: "",
                                              lastName: "",
                                              gender: "",
                                              dateOfBirth: "",
                                              id: 0,
                                              username: "")
}

typealias UsersResponseModel = [UserResponseModel]
