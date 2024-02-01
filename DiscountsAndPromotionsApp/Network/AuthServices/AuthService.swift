import Combine
import Foundation

protocol AuthServiceProtocol {
    var isTokenValidUpdate: PassthroughSubject<Bool, Never> { get }

    // в протоколе - обернутые в Task асинхронные методы актора
    func getToken(for user: UserRequestModel)
    func verifyToken()
    func refreshToken()
    func logout()
 }

actor AuthService: AuthServiceProtocol {
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    private let userDefaults = UserDefaults.standard
    private let tokenStorage: AuthTokenStorage

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
    nonisolated func getToken(for user: UserRequestModel) {
        Task { await requestToken(for: user)}
    }

    private func requestToken(for user: UserRequestModel) async {
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

    // MARK: - Проверить, что токен действителен
    nonisolated func verifyToken() {
        Task {
            if !userDefaults.bool(forKey: "isTokenSaved") { await clearStoredTokens() }
            await requestVerification()
        }
    }

    private func requestVerification() async {
        guard let token = tokenStorage.accessToken else {
            isTokenValid = false
            return
        }
        let access: String = token
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

        do {
            let _: URLResponse = try await networkClient.request(for: urlRequest)
            print("Token is valid")

            isTokenValid = true
        } catch let error {
            print("Token validation error: \(error.localizedDescription). Refreshing")
            refreshToken()
        }
    }

    // MARK: - Обновить токен, если он просрочен
    nonisolated func refreshToken() {
        Task { await requestRefresh() }
    }

    func requestRefresh() async {
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

        do {
            let token: TokenResponseModel = try await networkClient.request(for: urlRequest)
            print("Token is refreshed")

            isTokenValid = true
            tokenStorage.accessToken = token.access

        } catch let error {
            print("Token refresh error: \(error.localizedDescription)")

            isTokenValid = false
            logout()
            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    // MARK: - Удалить из связки ключей сохраненный токен
    nonisolated func logout() {
        Task { await clearStoredTokens() }
    }

    private func clearStoredTokens() {
        tokenStorage.clearTokenStorage()
    }
}
