import Foundation

enum L10n {
    enum LaunchScreen {
        static let cherryDescription = NSLocalizedString("cherryDescription", tableName: "LaunchScreen", comment: "")
    }

    enum Authorization {
        static let entryTitle = NSLocalizedString("entry", tableName: "AuthFlow", comment: "")
        static let emailTitle = NSLocalizedString("email", tableName: "AuthFlow", comment: "")
        static let passwordTitle = NSLocalizedString("password", tableName: "AuthFlow", comment: "")
        static let forgotPasswordTitle = NSLocalizedString("forgotPassword", tableName: "AuthFlow", comment: "")
        static let loginTitle = NSLocalizedString("login", tableName: "AuthFlow", comment: "")
        static let registerTitle = NSLocalizedString("register", tableName: "AuthFlow", comment: "")
        static let authorizationError = NSLocalizedString("authorizationError", tableName: "AuthFlow", comment: "")
    }
}
