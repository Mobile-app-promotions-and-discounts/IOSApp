import Foundation
import Combine

protocol LoginViewModelProtocol {
    var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never> { get }
    func didTapLoginButton(userEmail: String?, userPassword: String?)
}
