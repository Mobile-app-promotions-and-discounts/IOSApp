import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private(set) var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never>
    private(set) var userEmail: CurrentValueSubject<String, Never>
    private(set) var userPassword: CurrentValueSubject<String, Never>

    var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(userEmail, userPassword)
            .receive(on: DispatchQueue.main)
            .map { userName, password in
                return !userName.isEmpty && !password.isEmpty
            } .eraseToAnyPublisher()
    }

    private var cancellables: Set<AnyCancellable>

    private let authService: AuthServiceProtocol

    init() {
        self.isUserAuthorizedUpdate = PassthroughSubject<Bool, Never>()
        self.userEmail = CurrentValueSubject("")
        self.userPassword = CurrentValueSubject("")
        self.cancellables = Set<AnyCancellable>()
        self.authService = AuthService(networkClient: NetworkClient())
        self.bindingOn()
    }

    func didTapLoginButton() {
        checkUserAuthData()
    }

    func changeUserEmail(_ newEmail: String) {
        userEmail.send(newEmail)
    }

    func changePassword(_ newPassword: String) {
        userPassword.send(newPassword)
    }

    func bindingOff() {
        cancellables.removeAll()
    }

    func checkUserEmail() -> Bool {
        return userEmail.value.contains("@")
    }

    private func checkUserAuthData() {
        let userModel = UserRequestModel(username: userEmail.value,
                                         password: userPassword.value)
        authService.getToken(for: userModel)
    }

    func bindingOn() {
        authService.isTokenValidUpdate
            .sink { [weak self] isUpdate in
                self?.isUserAuthorizedUpdate.send(isUpdate)
            }.store(in: &cancellables)
    }
}
