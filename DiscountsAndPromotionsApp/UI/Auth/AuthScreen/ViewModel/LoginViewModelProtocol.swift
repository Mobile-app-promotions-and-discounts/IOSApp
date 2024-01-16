import Foundation
import Combine

protocol LoginViewModelProtocol {
    var isUserAuthorizedUpdate: PassthroughSubject<Bool, Never> { get }
    var userEmail: CurrentValueSubject<String, Never> { get }
    var userPassword: CurrentValueSubject<String, Never> { get }
    var validToSubmit: AnyPublisher<Bool, Never> { get }
    
    func didTapLoginButton()
    func bindingOff()
    func changeUserEmail(_ newEmail: String)
    func changePassword(_ newPassword: String)
}
