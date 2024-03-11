import Combine
import Foundation

protocol UserNetworkServiceProtocol {
    var user: CurrentValueSubject<UserResponseModel, Never> { get }

    func registerUser(_ user: UserRequestModel)
    func deleteUser(id: Int, password: String)
    func editUser(_ profileModel: ProfileUIModel)
    func fetchUser()
}

actor UserNetworkService: UserNetworkServiceProtocol {
    nonisolated static let shared = UserNetworkService(networkClient: NetworkClient())
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let user: CurrentValueSubject<UserResponseModel, Never>

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
        self.user = CurrentValueSubject(UserResponseModel.emptyModel)
    }

    // MARK: - Получить данные пользователя
    nonisolated func fetchUser() {
        Task { await getUser() }
    }

    private func getUser() async {
        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getUser,
                                                              additionalPath: nil,
                                                              headers: headers,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
                print("User info obtained successfully")
                user.send(userResponse)
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

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .newUser,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: userParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserShotResponseModel = try await networkClient.request(for: urlRequest)
            print("Registration successful")
            let userResponseModel = UserResponseModel(phone: self.user.value.phone,
                                                      role: self.user.value.role,
                                                      photo: self.user.value.photo,
                                                      firstName: self.user.value.firstName,
                                                      lastName: self.user.value.lastName,
                                                      gender: self.user.value.gender,
                                                      dateOfBirth: self.user.value.dateOfBirth,
                                                      id: userResponse.id,
                                                      username: userResponse.username)

            self.user.send(userResponseModel)
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

        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .deleteUser,
                                                              additionalPath: "\(id)/",
                                                              headers: headers,
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
    nonisolated func editUser(_ profileModel: ProfileUIModel) {
        let params = profileModel.getParametres(from: user.value)
        Task { await requestUserEdits(params, id: user.value.id) }
    }

    private func requestUserEdits(_ newUserParameters: [String: Any], id: Int) async {

        guard !newUserParameters.isEmpty else { return }
        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .editUser,
                                                              additionalPath: "\(id)/",
                                                              headers: headers,
                                                              parameters: newUserParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
            print("User info edited")

            self.user.send(userResponse)
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
