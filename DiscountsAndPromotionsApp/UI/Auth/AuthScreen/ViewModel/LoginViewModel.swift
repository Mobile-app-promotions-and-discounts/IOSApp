import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private(set) var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never>
    private(set) var userEmail: CurrentValueSubject<String,Never>
    private(set) var userPassword: CurrentValueSubject<String,Never>
    
    var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(userEmail, userPassword)
            .receive(on: RunLoop.main)
            .map {
                userName, password in
                return !userName.isEmpty && !password.isEmpty
            } .eraseToAnyPublisher()
    }

    private var isUserAuthorized: Bool {
        didSet {
            isUserAuthorizedUpdate.send(isUserAuthorized)
        }
    }
    
    private let authService: AuthServiceProtocol

    init() {
        self.isUserAuthorizedUpdate = PassthroughSubject<Bool, Never>()
        self.userEmail = CurrentValueSubject("")
        self.userPassword = CurrentValueSubject("")
        self.authService = AuthService(networkClient: NetworkClient())
        self.isUserAuthorized = false
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

    private func checkUserAuthData() {
        let userModel = UserRequestModel(username: userEmail.value, password: userPassword.value)
        authService.getToken(for: userModel)
        
//        let isEmailCorrect = userEmail == "ivanov@example.com"
//        let isPasswordCorrect = userPassword == "cherryapp"
//        isUserAuthorized = isEmailCorrect && isPasswordCorrect
    }
}
