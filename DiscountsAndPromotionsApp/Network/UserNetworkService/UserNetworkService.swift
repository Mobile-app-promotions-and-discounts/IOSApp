import Combine
import Foundation

protocol UserNetworkServiceProtocol {
    var userUpdate: PassthroughSubject<UserResponseModel, Never> { get }
    
    func registerUser(_ user: UserRequestModel)
    func deleteUser(id: Int, password: String)
    func editUser(_ newUserParameters: [String: Any], id: Int)
    func fetchUser()
}

actor UserNetworkService: UserNetworkServiceProtocol {
    nonisolated static let shared = UserNetworkService(networkClient: NetworkClient())
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let userUpdate = PassthroughSubject<UserResponseModel, Never>()
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

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    // MARK: - Получить данные пользователя
    nonisolated func fetchUser() {
        Task { await getUser() }
    }

    private func getUser() async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getUser,
                                                              additionalPath: nil,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
                print(userResponse)
                print("User info obtained successfully")
                user = userResponse
        } catch let error {
            print("Error getting user: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    // MARK: - Регистрация нового пользователя
    nonisolated func registerUser(_ user: UserRequestModel) {
        Task { await newUser(user) }
    }

    func newUser(_ user: UserRequestModel) async {
        let userParameters: [String: String] = [
            "username": user.username,
            "password": user.password
        ]
        print(userParameters)

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .newUser,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: userParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
            print(userResponse)
            print("Registration successful")

            self.user = userResponse
        } catch let error {
            print("Registration error: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    // MARK: - Удалить пользователя
    nonisolated func deleteUser(id: Int, password: String) {
        Task { await requestDeleteUser(id: id, password: password) }
    }

    func requestDeleteUser(id: Int, password: String) async {
        let parameters = [
            "current_password": password
        ]

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .deleteUser,
                                                              additionalPath: "\(id)/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: parameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let _: URLResponse = try await networkClient.request(for: urlRequest)
            print("Account successfuly deleted")
            // TODO: - отработать действия при удалении аккаунта
        } catch let error {
            print("Account deletion error: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    // MARK: - Отредактировать пользователя (передать новые ключи + значения)
    nonisolated func editUser(_ newUserParameters: [String: Any], id: Int) {
        Task { await requestUserEdits(newUserParameters, id: id) }
    }

    private func requestUserEdits(_ newUserParameters: [String: Any], id: Int) async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .deleteUser,
                                                              additionalPath: "\(id)/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: newUserParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
            print(userResponse)
            print("User info edited")

            self.user = userResponse
        } catch let error {
            print("User info editing error: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }
}
