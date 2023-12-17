import Combine
import Foundation

protocol AuthServiceProtocol {
    var isTokenValidUpdate: PassthroughSubject<Bool, Never> { get }

    func getToken(for user: UserRequestModel)
//    func verifyToken()
//    func refreshToken()
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
//    func verifyToken() {
//        let access: String = tokenStorage.accessToken ?? ""
//        let tokenParams: [String: String] = [
//            "token": access
//        ]
//
//        let publisher: AnyPublisher<Data, AppError> = networkClient.requestWithEmptyResponse(
//            endpoint: Endpoint.verifyToken,
//            additionalPath: nil,
//            headers: nil,
//            parameters: tokenParams)
//
//        publisher
//            .sink { [weak self] completion in
//            switch completion {
//            case .finished:
//                print("Token is valid")
//                self?.isTokenValidUpdate.send(true)
//            case .failure(let error):
//                print("Token validation error: \(error)")
//                self?.refreshToken()
//            }
//        } receiveValue: { _ in }
//        .store(in: &subscriptions)
//    }

    // MARK: - Обновить токен, если он просрочен
//    func refreshToken() {
//        let refresh: String = tokenStorage.refreshToken ?? ""
//        let tokenParams: [String: String] = [
//            "refresh": refresh
//        ]
//
//        let publisher: AnyPublisher<TokenResponseModel, AppError> = networkClient.request(
//            endpoint: Endpoint.refreshToken,
//            additionalPath: nil,
//            headers: nil,
//            parameters: tokenParams)
//
//        publisher
//            .sink { [weak self] completion in
//            switch completion {
//            case .finished:
//                print("Token is refreshed")
//            case .failure(let error):
//                print("Token refresh error: \(error)")
//                self?.isTokenValidUpdate.send(false)
//            }
//        } receiveValue: { [weak self] token in
//            self?.tokenStorage.accessToken = token.access
//            self?.isTokenValidUpdate.send(true)
//        }
//        .store(in: &subscriptions)
//    }

    // MARK: - Удалить из связки ключей сохраненный токен
    func logout() {
        tokenStorage.clearTokenStorage()
    }
}
