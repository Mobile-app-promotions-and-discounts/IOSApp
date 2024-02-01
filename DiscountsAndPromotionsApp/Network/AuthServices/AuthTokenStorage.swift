import Foundation
import SwiftKeychainWrapper

final class AuthTokenStorage {
    static let shared = AuthTokenStorage()

    private let wrapper = KeychainWrapper.standard
    private let userDefaults = UserDefaults.standard

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
            userDefaults.set(true, forKey: "isTokenSaved")

            if !isSuccess {
                ErrorHandler.handle(error: .customError("Access token saving error"))
            }
        }
    }

    var refreshToken: String? {
        get {
            wrapper.string(forKey: Keys.refreshToken.rawValue)
        }
        set {
            guard let newToken = newValue else { return }
            let isSuccess = wrapper.set(newToken, forKey: Keys.refreshToken.rawValue)
            userDefaults.set(true, forKey: "isTokenSaved")

            if !isSuccess {
                ErrorHandler.handle(error: .customError("Refresh token saving error"))
            }
        }
    }

    private init() {}

    func clearTokenStorage() {
        wrapper.remove(forKey: KeychainWrapper.Key(rawValue: Keys.accessToken.rawValue))
        wrapper.remove(forKey: KeychainWrapper.Key(rawValue: Keys.refreshToken.rawValue))
        userDefaults.set(false, forKey: "isTokenSaved")
    }
}
