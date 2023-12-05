import Combine
import Foundation

protocol AuthServiceProtocol {
    func getToken(for user: UserRequestModel)
}

final class AuthService: AuthServiceProtocol {
    private let tokenStorage: AuthTokenStorage
    private let networkService: NetworkServiceProtocol

    private var subscriptions = Set<AnyCancellable>()

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage.shared, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.tokenStorage = tokenStorage
        self.networkService = networkService
    }

    func getToken(for user: UserRequestModel) {
        let userParams: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        let publisher: AnyPublisher<TokenResponseModel, AppError> = networkService.request(endpoint: Endpoint.getToken, headers: nil, parameters: userParams)

        publisher.sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] token in
            print("Received value: \(token)")
            self?.tokenStorage.accessToken = token.access
        }
        .store(in: &subscriptions)
    }
}
