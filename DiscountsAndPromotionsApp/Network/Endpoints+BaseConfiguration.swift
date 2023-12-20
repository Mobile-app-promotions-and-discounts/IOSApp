import Foundation

enum Endpoint {
    case getToken
    case verifyToken
    case refreshToken
    case getUser
    case deleteUser
    case newUser
    case editUser
    case getCategories
    case getCategory
    case getStores
    case getStoreChains
    case getStoreChain
    case getCategoryProducts
    case getProduct

    var URL: String {
        var path = NetworkBaseConfiguration.baseURL
        switch self {
        case .getToken:
            path += "/auth/jwt/create/"
        case .verifyToken:
            path += "/auth/jwt/verify/"
        case .refreshToken:
            path += "/auth/jwt/refresh/"
        case .getUser:
            path += "/auth/users/me/"
        case .deleteUser, .newUser, .editUser:
            path += "/auth/users/"
        case .getCategory, .getCategories:
            path += "/api/v1/categories/"
        case .getStores:
            path += "/api/v1/stores/"
        case .getStoreChain, .getStoreChains:
            path += "/api/v1/chains/"
        case .getProduct, .getCategoryProducts:
            path += "/api/v1/products/"
        }
        return path
    }

    var method: HttpMethod {
        switch self {
        case .getToken,
                .refreshToken,
                .verifyToken,
                .newUser:
            return .post
        case .getUser,
                .getCategory,
                .getCategories,
                .getCategoryProducts,
                .getProduct,
                .getStores,
                .getStoreChain,
                .getStoreChains:
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
    static func accessTokenHeader() -> [String: String] {
        let token = AuthTokenStorage.shared.accessToken ?? ""
        return ["Authorization": "Bearer \(token)"]
    }
}
