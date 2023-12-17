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

    private (set) var isTokenValidUpdate = PassthroughSubject<Bool, Never>()

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage.shared,
         networkClient: NetworkClientProtocol) {
        self.tokenStorage = tokenStorage
        self.networkClient = networkClient
    }

    // MARK: - Авторизоваться и получить токен
    func getToken(for user: UserRequestModel) {
        var subscriptions = Set<AnyCancellable>()

        let userParams: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        let publisher: AnyPublisher<TokenResponseModel, AppError> = networkClient.request(
            endpoint: Endpoint.getToken,
            additionalPath: nil,
            headers: nil,
            parameters: userParams
        )

        publisher.sink { [weak self] completion in
            switch completion {
            case .finished:
                print("Token obtained successfully")
                self?.isTokenValidUpdate.send(true)
            case .failure(let error):
                print("Error getting token: \(error)")
                self?.isTokenValidUpdate.send(false)
            }
        } receiveValue: { [weak self] token in
            self?.tokenStorage.accessToken = token.access
            if let refresh = token.refresh {
                self?.tokenStorage.refreshToken = refresh
            }
        }
        .store(in: &subscriptions)
    }

    // MARK: - Проверить, что токен действителен
    func verifyToken() {
        var subscriptions = Set<AnyCancellable>()

        let access: String = tokenStorage.accessToken ?? ""
        let tokenParams: [String: String] = [
            "token": access
        ]

        let publisher: AnyPublisher<Data, AppError> = networkClient.requestWithEmptyResponse(
            endpoint: Endpoint.verifyToken,
            additionalPath: nil,
            headers: nil,
            parameters: tokenParams)

        publisher
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                print("Token is valid")
            case .failure(let error):
                print("Token validation error: \(error)")
                self?.refreshToken()
            }
        } receiveValue: { _ in }
        .store(in: &subscriptions)
    }

    // MARK: - Обновить токен, если он просрочен
    func refreshToken() {
        var subscriptions = Set<AnyCancellable>()

        let refresh: String = tokenStorage.refreshToken ?? ""
        let tokenParams: [String: String] = [
            "refresh": refresh
        ]

        let publisher: AnyPublisher<TokenResponseModel, AppError> = networkClient.request(
            endpoint: Endpoint.refreshToken,
            additionalPath: nil,
            headers: nil,
            parameters: tokenParams)

        publisher
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                print("Token is valid")
            case .failure(let error):
                print("Token validation error: \(error)")
                self?.refreshToken()
            }
        } receiveValue: { [weak self] token in
            self?.tokenStorage.accessToken = token.access
        }
        .store(in: &subscriptions)
    }

    // MARK: - Удалить из связки ключей сохраненный токен
    func logout() {
        tokenStorage.clearTokenStorage()
    }
}
