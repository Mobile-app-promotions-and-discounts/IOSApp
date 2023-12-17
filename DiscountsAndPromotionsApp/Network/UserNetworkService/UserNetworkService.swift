import Combine
import Foundation

protocol UserNetworkServiceProtocol {
    var userUpdate: PassthroughSubject<UserResponseModel, Never> { get }

    func registerUser(_ user: UserRequestModel)
    func deleteUser(id: Int, password: String)
    func editUser(_ newUserParameters: [String: Any], id: Int)
    func fetchUser()
}

 final class UserNetworkService: UserNetworkServiceProtocol {
    static let shared = UserNetworkService(networkClient: NetworkClient())
    private var networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

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

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    // MARK: - Получить данные пользователя
    func fetchUser() {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getUser,
                                                              additionalPath: nil,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(userResponse)
                    print("User info obtained successfully")

                    guard let self else { return }
                    self.user = userResponse
                }
            } catch let error {
                print("Error getting user: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

     // MARK: - Регистрация нового пользователя
     func registerUser(_ user: UserRequestModel) {
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

         Task {
             do {
                 let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
                 await MainActor.run { [weak self] in
                     print(userResponse)
                     print("Registration successful")

                     guard let self else { return }
                     self.user = userResponse
                 }
             } catch let error {
                 print("Registration error: \(error.localizedDescription)")

                 if let error = error as? AppError {
                     ErrorHandler.handle(error: error)
                 } else {
                     ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                 }
             }
         }
     }

    // MARK: - Удалить пользователя
    func deleteUser(id: Int, password: String) {
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

        Task {
            do {
                let response: NetworkErrorDescriptionModel = try await networkClient.request(for: urlRequest)
                await MainActor.run {
                    print(response)
                    print("Account successfuly deleted")

                    // TODO: - отработать действия при удалении аккаунта
                }
            } catch let error {
                print("Account deletion error: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    // MARK: - Отредактировать пользователя (передать новые ключи + значения)
    func editUser(_ newUserParameters: [String: Any], id: Int) {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .deleteUser,
                                                              additionalPath: "\(id)/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: newUserParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let userResponse: UserResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(userResponse)
                    print("User info edited")

                    guard let self else { return }
                    self.user = userResponse
                }
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
 }
