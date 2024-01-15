import Combine
import Foundation

final class RegistrationViewModel: RegistrationViewModelProtocol {
    private(set) var userEmail: CurrentValueSubject<String,Never>
    private(set) var userPassword: CurrentValueSubject<String,Never>
    private(set) var isUserAuthorizatedUpdate: PassthroughSubject<Bool, Never>
    private var cancellables: Set<AnyCancellable>
    
    var validToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(userEmail, userPassword)
            .receive(on: DispatchQueue.main)
            .map {
                userName, password in
                return !userName.isEmpty && !password.isEmpty
            } .eraseToAnyPublisher()
    }
    
    private let userNetworkService: UserNetworkServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(userNetworkService: UserNetworkServiceProtocol, authService: AuthServiceProtocol) {
        self.userEmail = CurrentValueSubject("")
        self.userPassword = CurrentValueSubject("")
        self.isUserAuthorizatedUpdate = PassthroughSubject<Bool, Never>()
        self.cancellables = Set<AnyCancellable>()
        self.userNetworkService = userNetworkService
        self.authService = authService
        netWorkBinds()
    }
    
    func didTapLoginButton() {
        let userModel = UserRequestModel(username: userEmail.value,
                                         password: userPassword.value)
        userNetworkService.registerUser(userModel)
    }
    
    func didTapPrivacyPolicy() {
        // TODO: - открыть экран политики конфидециальности
    }
    
    func changeUserEmail(_ newEmail: String) {
        userEmail.send(newEmail)
    }
    
    func changePassword(_ newPassword: String) {
        userPassword.send(newPassword)
    }
    
    private func netWorkBinds() {
        userNetworkService.userShotUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userShotResponseModel in
                print(userShotResponseModel)
                self?.getAutorizated(userName: userShotResponseModel.username,
                                     password: userShotResponseModel.password)
            }.store(in: &cancellables)
        
        authService.isTokenValidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAutorizated in
                print(isAutorizated)
                self?.isUserAuthorizatedUpdate.send(isAutorizated)
            }.store(in: &cancellables)
    }
    
    private func getAutorizated(userName:String, password: String) {
        let userRequestModel = UserRequestModel(username: userName,
                                                password: password)
        authService.getToken(for: userRequestModel)
    }

}
