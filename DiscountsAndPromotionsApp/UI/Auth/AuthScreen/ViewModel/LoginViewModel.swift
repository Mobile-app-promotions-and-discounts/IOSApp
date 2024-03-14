import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private(set) var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never>
    private(set) var userEmail: CurrentValueSubject<String, Never>
    private(set) var userPassword: CurrentValueSubject<String, Never>
    private(set) var networkActive: CurrentValueSubject<Bool, Never>

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
        self.networkActive = CurrentValueSubject(false)
        self.cancellables = Set<AnyCancellable>()
        self.authService = AuthService(networkClient: NetworkClient())
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

    func viewWillAppear() {
        bindingOn()
    }

    func viewWillDisappear() {
        bindingOff()
    }

    func checkUserEmail() -> Bool {
        return userEmail.value.contains("@")
    }

    private func checkUserAuthData() {
        networkActive.send(true)
        let userModel = UserRequestModel(username: userEmail.value,
                                         password: userPassword.value)
        authService.getToken(for: userModel)
    }

    private func bindingOn() {
        authService.isTokenValidUpdate
            .sink { [weak self] isUpdate in
                self?.isUserAuthorizedUpdate.send(isUpdate)
                self?.networkActive.send(false)
            }.store(in: &cancellables)
    }

    private func bindingOff() {
        cancellables.removeAll()
    }
}
