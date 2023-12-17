import Foundation
import SwiftKeychainWrapper

protocol AuthTokenStorageProtocol {
    var token: String? { get }
    func setTokenValue(newValue: String) -> Bool
}

final class AuthTokenKeychainStorage: AuthTokenStorageProtocol {

    static let shared = AuthTokenKeychainStorage()

    private enum Keys: String {
        case accessToken
    }

    var token: String? {
        guard let token = KeychainWrapper.standard.string(forKey: Keys.accessToken.rawValue) else {
            return nil
        }
        return token
    }

    private init() {}

    func setTokenValue(newValue: String) -> Bool {
        let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.accessToken.rawValue)
        return isSuccess
    }
}
