import Combine
import Foundation

protocol RegistrationViewModelProtocol {
    var userEmail: CurrentValueSubject<String, Never> { get }
    var userPassword: CurrentValueSubject<String, Never> { get }
    var isUserAuthorizatedUpdate: PassthroughSubject<Bool, Never> { get }
    var validToSubmit: AnyPublisher<Bool, Never> { get }

    func didTapLoginButton()
    func didTapPrivacyPolicy()
    func viewWillAppear()
    func viewWillDisappear()
    func changeUserEmail(_ newEmail: String)
    func changePassword(_ newPassword: String)
}
