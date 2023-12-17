import Combine
import Foundation

protocol AuthServiceProtocol {
    var isTokenValidUpdate: PassthroughSubject<Bool, Never> { get }

    func getToken(for user: UserRequestModel)
    func verifyToken()
    func refreshToken()
    func logout()
}

final class AuthService: AuthServiceProtocol {
    private let tokenStorage: AuthTokenStorage
    private let networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

    var subscriptions = Set<AnyCancellable>()

    private (set) var isTokenValidUpdate = PassthroughSubject<Bool, Never>()

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
                await MainActor.run { [weak self] in
                    print(token)
                    print("Token obtained successfully")

                    guard let self else { return }
                    self.isTokenValidUpdate.send(true)
                    self.tokenStorage.accessToken = token.access
                    if let refresh = token.refresh {
                        self.tokenStorage.refreshToken = refresh
                    }
                }
            } catch let error {
                print("Error getting token: \(error.localizedDescription)")

                isTokenValidUpdate.send(false)
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
                let responseData: NetworkErrorDescriptionModel = try await networkClient.request(for: urlRequest)
                await MainActor.run {[weak self] in
                    print(responseData)
                    print("Token is valid")

                    guard let self else { return }
                    self.isTokenValidUpdate.send(true)
                }
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
                await MainActor.run { [weak self] in
                    print(token)
                    print("Token is refreshed")

                    guard let self else { return }
                    self.isTokenValidUpdate.send(true)
                    self.tokenStorage.accessToken = token.access
                }
            } catch let error {
                print("Token refresh error: \(error.localizedDescription)")

                isTokenValidUpdate.send(false)
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
