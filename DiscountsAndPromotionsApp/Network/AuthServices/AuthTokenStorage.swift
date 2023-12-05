import Foundation
import SwiftKeychainWrapper

final class AuthTokenStorage {
    private let wrapper = KeychainWrapper.standard

    private enum Keys: String {
        case refreshToken
        case accessToken
    }

    var accessToken: String? {
        get {
            wrapper.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            guard let newToken = newValue else { return }
            let isSuccess = wrapper.set(newToken, forKey: Keys.accessToken.rawValue)

            if !isSuccess {
                ErrorHandler.handle(error: .customError("Access token saving error"))
            }
        }
    }

    func clearTokenStorage() {
        wrapper.remove(forKey: KeychainWrapper.Key(rawValue: Keys.accessToken.rawValue))
    }
}
