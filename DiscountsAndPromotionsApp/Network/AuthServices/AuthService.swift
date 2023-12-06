import Combine
import Foundation

protocol AuthServiceProtocol {
    func getToken(for user: UserRequestModel)
    func logout()
}

final class AuthService: AuthServiceProtocol {
    static let shared = AuthService()

    private let tokenStorage: AuthTokenStorage
    private let networkClient: NetworkClientProtocol

    private var subscriptions = Set<AnyCancellable>()

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage.shared,
         networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.tokenStorage = tokenStorage
        self.networkClient = networkClient
    }

    // MARK: - Авторизоваться и получить токен
    func getToken(for user: UserRequestModel) {
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

        publisher.sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
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
