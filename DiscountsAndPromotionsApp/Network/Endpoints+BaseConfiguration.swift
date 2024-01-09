import Foundation

enum Endpoint {
    // token
    case getToken
    case verifyToken
    case refreshToken
    // user
    case getUser
    case deleteUser
    case newUser
    case editUser
    // categories
    case getCategories
    case getCategory
    // stores
    case getStores
    case getStoreChains
    case getStoreChain
    // products
    case getProducts
    case getProduct
    // favorites
    case getFavorites
    case addToFavorites
    case removeFromFavorites
    // reviews
    case getProductReviews
    case postNewReview

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
        case .getProduct, .getProducts, .addToFavorites, .removeFromFavorites, .getProductReviews, .postNewReview:
            path += "/api/v1/products/"
        case .getFavorites:
            path += "/api/v1/products/favorites/"
        }
        return path
    }

    var method: HttpMethod {
        switch self {
        case .getToken,
                .refreshToken,
                .verifyToken,
                .newUser,
                .addToFavorites,
                .postNewReview:
            return .post
        case .getUser,
                .getCategory,
                .getCategories,
                .getProducts,
                .getProduct,
                .getStores,
                .getStoreChain,
                .getStoreChains,
                .getFavorites,
                .getProductReviews:
            return .get
        case .deleteUser, .removeFromFavorites:
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
    static let testUser = UserRequestModel(username: "petrov@example.com",
                                           password: "cherryapp")
    static let baseURL = "http://193.107.239.130"
    static func accessTokenHeader() -> [String: String] {
        let token = AuthTokenStorage.shared.accessToken ?? ""
        return ["Authorization": "Bearer \(token)"]
    }
}
