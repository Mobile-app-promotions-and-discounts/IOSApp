import Combine
import Foundation

protocol UserNetworkServiceProtocol {
    var userUpdate: PassthroughSubject<UserResponseModel, Never> { get }

    func registerUser(_ user: UserRequestModel)
    func deleteUser(id: Int, password: String)
    func editUser(_ newUserParameters: [String: String], id: Int)
    func fetchUser()
}

final class UserNetworkService: UserNetworkServiceProtocol {
    static let shared = UserNetworkService()

    private var networkClient: NetworkClientProtocol
    private var subscriptions = Set<AnyCancellable>()

    private var user = UserResponseModel(phone: "",
                                         role: "",
                                         foto: "",
                                         firstName: "",
                                         lastName: "",
                                         id: 0,
                                         username: "") {
        didSet {
            userUpdate.send(user)
        }
    }
    private (set) var userUpdate = PassthroughSubject<UserResponseModel, Never>()

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

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &subscriptions)
    }

    // MARK: - Регистрация нового пользователя
    func registerUser(_ user: UserRequestModel) {
        let userParameters: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        let publisher: AnyPublisher<UserResponseModel, AppError> = networkClient.request(
            endpoint: .newUser,
            additionalPath: nil,
            headers: nil,
            parameters: userParameters
        )

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &subscriptions)
    }

    // MARK: - Удалить пользователя
    func deleteUser(id: Int, password: String) {
        let parameters = [
            "current_password": password
        ]
        let publisher: AnyPublisher<Data, AppError> = networkClient.requestWithEmptyResponse(
            endpoint: .deleteUser,
            additionalPath: "\(id)",
            headers: NetworkBaseConfiguration.tokenHeader(),
            parameters: parameters
        )

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
                // TODO: отработать действия при удалении аккаунта
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: {data in
            print(data)
        }
        .store(in: &subscriptions)
    }

    // MARK: - Отредактировать пользователя (передать новые ключи + значения)
    func editUser(_ newUserParameters: [String: String], id: Int) {
        let publisher: AnyPublisher<UserResponseModel, AppError> = networkClient.request(
            endpoint: .newUser,
            additionalPath: "\(id)",
            headers: NetworkBaseConfiguration.tokenHeader(),
            parameters: newUserParameters
        )

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &subscriptions)
    }
}
