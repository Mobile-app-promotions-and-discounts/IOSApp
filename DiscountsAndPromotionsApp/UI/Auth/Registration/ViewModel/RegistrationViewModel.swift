import Combine
import Foundation

class RegistrationViewModel: RegistrationViewModelProtocol {
    private(set) var userEmail: CurrentValueSubject<String,Never>
    private(set) var userPassword: CurrentValueSubject<String,Never>
    
    var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(userEmail, userPassword)
            .receive(on: DispatchQueue.main)
            .map {
                userName, password in
                return !userName.isEmpty && !password.isEmpty
            } .eraseToAnyPublisher()
    }
    
    private let userNetworkService: UserNetworkServiceProtocol
    
    init() {
        self.userEmail = CurrentValueSubject("")
        self.userPassword = CurrentValueSubject("")
        self.userNetworkService = UserNetworkService(networkClient: NetworkClient())
    }
    
    func didTapLoginButton() {
        // TODO: - отправить запрос на регистрацию нового пользователя, может быть это нужно сделать во вьюКонтроллере
    }
    
    func didTapPrivacyPolicy() {
        // TODO: - открыть экран политики конфидеальности
    }
    
    func changeUserEmail(_ newEmail: String) {
        userEmail.send(newEmail)
    }
    
    func changePassword(_ newPassword: String) {
        userPassword.send(newPassword)
    }
    
    
}
