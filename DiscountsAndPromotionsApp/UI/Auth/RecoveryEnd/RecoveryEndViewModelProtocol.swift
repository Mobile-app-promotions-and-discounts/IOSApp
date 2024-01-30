import Combine
import Foundation

protocol RecoveryEndViewModelProtocol {
    var password: CurrentValueSubject <String,Never> { get }
    var passwordIsNoEmpty: CurrentValueSubject <Bool, Never> { get }
    
    func changePassword(_ newPassword: String)
    func pressSign(completion: () -> Void)
}
