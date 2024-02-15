import Combine
import Foundation

final class RecoveryEndViewModel: RecoveryEndViewModelProtocol {
    private(set) var password: CurrentValueSubject<String, Never>
    private(set) var passwordIsNoEmpty: CurrentValueSubject<Bool, Never>

    init() {
        self.password = CurrentValueSubject("")
        self.passwordIsNoEmpty = CurrentValueSubject(false)
    }

    func changePassword(_ newPassword: String) {
        password.send(newPassword)
        if !newPassword.isEmpty {
            passwordIsNoEmpty.send(true)
        } else {
            passwordIsNoEmpty.send(false)
        }
    }

    func pressSign(completion: () -> Void) {
        completion()
    }

}
