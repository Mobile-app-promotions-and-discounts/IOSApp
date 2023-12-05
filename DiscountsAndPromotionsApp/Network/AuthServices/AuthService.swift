import Combine
import Foundation

protocol AuthServiceProtocol {
    func getToken(for user: UserRequestModel)
}

final class AuthService: AuthServiceProtocol {
    // временно для теста
    static let shared = AuthService()

    private let tokenStorage: AuthTokenStorage
    private let networkClient: NetworkClientProtocol

    private var subscriptions = Set<AnyCancellable>()

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage.shared,
         networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.tokenStorage = tokenStorage
        self.networkClient = networkClient
    }

    func getToken(for user: UserRequestModel) {
        let userParams: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        let publisher: AnyPublisher<TokenResponseModel, AppError> = networkClient.request(
            endpoint: Endpoint.getToken,
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
            print(self?.tokenStorage.accessToken)
        }
        .store(in: &subscriptions)
    }
}
