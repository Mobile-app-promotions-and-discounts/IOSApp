import Combine
import Foundation

// protocol AuthServiceProtocol {
//    var isTokenValidUpdate: PassthroughSubject<Bool, Never> { get }
//
//    func getToken(for user: UserRequestModel)
//    func verifyToken()
//    func refreshToken()
//    func logout()
// }

actor AuthService {
    private let tokenStorage: AuthTokenStorage
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let isTokenValidUpdate = PassthroughSubject<Bool, Never>()
    private var isTokenValid: Bool = false {
        didSet {
            isTokenValidUpdate.send(isTokenValid)
        }
    }

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage.shared,
         networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.tokenStorage = tokenStorage
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    // MARK: - Авторизоваться и получить токен
    func getToken(for user: UserRequestModel) {
        let userParams: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        guard let urlRequest = requestConstructor.makeRequest(endpoint: Endpoint.getToken,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: userParams) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let token: TokenResponseModel = try await networkClient.request(for: urlRequest)
                print("Token obtained successfully")

                isTokenValid = true
                tokenStorage.accessToken = token.access
                if let refresh = token.refresh {
                    tokenStorage.refreshToken = refresh
                }
            } catch let error {
                print("Error getting token: \(error.localizedDescription)")

                isTokenValid = false
                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Проверить, что токен действителен
    func verifyToken() {
        let access: String = tokenStorage.accessToken ?? ""
        let tokenParams: [String: String] = [
            "token": access
        ]

        guard let urlRequest = requestConstructor.makeRequest(endpoint: Endpoint.verifyToken,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: tokenParams) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let _: URLResponse = try await networkClient.request(for: urlRequest)
                print("Token is valid")

                isTokenValid = true
            } catch let error {
                print("Token validation error: \(error.localizedDescription). Refreshing")
                refreshToken()
            }
        }
    }

    // MARK: - Обновить токен, если он просрочен
    func refreshToken() {
        let refresh: String = tokenStorage.refreshToken ?? ""
        let tokenParams: [String: String] = [
            "refresh": refresh
        ]

        guard let urlRequest = requestConstructor.makeRequest(endpoint: Endpoint.refreshToken,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: tokenParams) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let token: TokenResponseModel = try await networkClient.request(for: urlRequest)
                print("Token is refreshed")

                isTokenValid = true
                tokenStorage.accessToken = token.access

            } catch let error {
                print("Token refresh error: \(error.localizedDescription)")

                isTokenValid = false
                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Удалить из связки ключей сохраненный токен
    func logout() {
        tokenStorage.clearTokenStorage()
    }
}
