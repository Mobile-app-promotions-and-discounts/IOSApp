import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private(set) var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never>
    private let authService: AuthServiceProtocol

    private var isUserAuthorized: Bool {
        didSet {
            isUserAuthorizedUpdate.send(isUserAuthorized)
        }
    }

    init() {
        self.isUserAuthorizedUpdate = PassthroughSubject<Bool, Never>()
        self.authService = AuthService(networkClient: NetworkClient())
        self.isUserAuthorized = false
    }

    func didTapLoginButton(userEmail: String?, userPassword: String?) {
        checkUserAuthData(userEmail: userEmail, userPassword: userPassword)
    }

    private func checkUserAuthData(userEmail: String?, userPassword: String?) {
        guard let userEmail = userEmail,
              let userPassword = userPassword else {
            isUserAuthorized = false
            return
        }
        let userModel = UserRequestModel(username: userEmail, password: userPassword)
        authService.getToken(for: userModel)
        
        let isEmailCorrect = userEmail == "ivanov@example.com"
        let isPasswordCorrect = userPassword == "cherryapp"
        isUserAuthorized = isEmailCorrect && isPasswordCorrect
    }
}
