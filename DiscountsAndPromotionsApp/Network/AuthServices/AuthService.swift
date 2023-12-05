import Foundation

final class AuthService {
    let tokenStorage: AuthTokenStorage

    init(tokenStorage: AuthTokenStorage = AuthTokenStorage()) {
        self.tokenStorage = tokenStorage
    }
}
