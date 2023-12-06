import Combine
import Foundation

protocol UserNetworkServiceProtocol {
    func registerUser(_ user: UserRequestModel)
    func deleteUser(id: Int, password: String)
    func editUser(_ newUser: UserResponseModel)
    func fetchUser()
}

final class UserNetworkService: UserNetworkServiceProtocol {
    static let shared = UserNetworkService()

    private var networkClient: NetworkClientProtocol
    private var subscriptions = Set<AnyCancellable>()

    init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }

    // MARK: - Получить данные пользователя
    func fetchUser() {
        let publisher: AnyPublisher<UserResponseModel, AppError> = networkClient.request(
            endpoint: .getUser,
            additionalPath: nil,
            headers: NetworkBaseConfiguration.tokenHeader(),
            parameters: nil
        )

        publisher.sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: {user in
            print(user)
        }
        .store(in: &subscriptions)
    }

    // MARK: - Регистрация нового пользователя
    func registerUser(_ user: UserRequestModel) {

    }

    // MARK: - Удалить пользователя
    func deleteUser(id: Int, password: String) {

    }

    // MARK: - Отредактировать пользователя (передать новый вид пользователя с прежним ID)
    func editUser(_ newUser: UserResponseModel) {

    }
}
