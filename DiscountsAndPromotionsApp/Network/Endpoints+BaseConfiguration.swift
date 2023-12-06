import Foundation

enum Endpoint {
    case getToken
    case getUser
    case deleteUser
    case newUser
    case editUser

    var URL: String {
        var path = NetworkBaseConfiguration.baseURL
        switch self {
        case .getToken:
            path += "/auth/jwt/create/"
        case .getUser:
            path += "/auth/users/me/"
        case .deleteUser, .newUser, .editUser:
            path += "/auth/users/"
        }
        return path
    }

    var method: HttpMethod {
        switch self {
        case .getToken, .newUser:
            return .post
        case .getUser:
            return .get
        case .deleteUser:
            return .delete
        case .editUser:
            return .patch
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: - Базовый URL и, тестовый пользователь, общие вспомогательные методы для формирования запросов
struct NetworkBaseConfiguration {
    static let testUser = UserRequestModel(username: "ivanov@example.com",
                                           password: "cherryapp")
    static let baseURL = "http://193.107.239.130"
    static func tokenHeader() -> [String: String] {
        let token = AuthTokenStorage.shared.accessToken ?? ""
        return ["Authorization": "Bearer \(token)"]
    }
}
