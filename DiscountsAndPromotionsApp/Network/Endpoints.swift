import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkBaseConfiguration {
    static let testUser = UserRequestModel(username: "ivanov@example.com",
                                           password: "cherryapp")
    static let baseURL = "http://193.107.239.130"

    static func tokenHeader() -> [String: String] {
        let token = AuthTokenStorage.shared.accessToken ?? ""
        return [
            "Bearer": token
        ]
    }
}

enum Endpoint {
    case getToken
    case getUser
    case deleteUser

    var URL: String {
        var path = NetworkBaseConfiguration.baseURL
        switch self {
        case .getToken:
            path += "/auth/jwt/create/"
        case .getUser:
            path += "/auth/users/me/"
        case .deleteUser:
            path += "/auth/users/me/"
        }
        return path
    }

    var method: HttpMethod {
        switch self {
        case .getToken:
            return .post
        case .getUser:
            return .get
        case .deleteUser:
            return .delete
        }
    }
}
