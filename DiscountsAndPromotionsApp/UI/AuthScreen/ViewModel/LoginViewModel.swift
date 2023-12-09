import Foundation
import Combine

final class LoginViewModel: LoginViewModelProtocol {

    private(set) var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never>

    private var isUserAuthorized: Bool {
        didSet {
            isUserAuthorizedUpdate.send(isUserAuthorized)
        }
    }

    init() {
        self.isUserAuthorizedUpdate = PassthroughSubject<Bool, Never>()
        self.isUserAuthorized = false
    }

    func didTapLoginButton(userEmail: String?, userPassword: String?) {
        checkUserAuthData(userEmail: userEmail, userPassword: userPassword)
    }

    private func checkUserAuthData(userEmail: String?, userPassword: String?) {
        let isEmailCorrect = userEmail == "ivanov@example.com"
        let isPasswordCorrect = userPassword == "cherryapp"
        isUserAuthorized = isEmailCorrect && isPasswordCorrect
    }
}
