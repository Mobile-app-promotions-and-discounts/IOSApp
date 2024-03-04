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
    }
    enum Registration {
        static let entryTitle = NSLocalizedString("entry", tableName: "RegistrationFlow", comment: "")
        static let emailTitle = NSLocalizedString("email", tableName: "RegistrationFlow", comment: "")
        static let passwordTitle = NSLocalizedString("password", tableName: "RegistrationFlow", comment: "")
        static let privacyPolicyTitle = NSLocalizedString("privacyPolicyTitle", tableName: "RegistrationFlow", comment: "")
        static let privacyPolicy = NSLocalizedString("privacyPolicy", tableName: "RegistrationFlow", comment: "")
        static let registrationTitle = NSLocalizedString("registration", tableName: "RegistrationFlow", comment: "")
    }
    enum Location {
        static let welcome = NSLocalizedString("welcome", tableName: "LocationFlow", comment: "")
        static let enterCity = NSLocalizedString("enterCity", tableName: "LocationFlow", comment: "")
        static let automatical = NSLocalizedString("automatical", tableName: "LocationFlow", comment: "")
        static let manual = NSLocalizedString("manual", tableName: "LocationFlow", comment: "")
    }
    enum RecoveryStart {
        static let title = NSLocalizedString("title", tableName: "RecoveryStartFlow", comment: "")
        static let time = NSLocalizedString("time", tableName: "RecoveryStartFlow", comment: "")
        static let recoveryButton = NSLocalizedString("recovery", tableName: "RecoveryStartFlow", comment: "")
        static let sendCode = NSLocalizedString("sendCode", tableName: "RecoveryStartFlow", comment: "")
        static let sendCodeButton = NSLocalizedString("sendCodeButton", tableName: "RecoveryStartFlow", comment: "")
        static let sentCode = NSLocalizedString("sentCode", tableName: "RecoveryStartFlow", comment: "")
        static let willSendCode = NSLocalizedString("willSendCode", tableName: "RecoveryStartFlow", comment: "")
        static let recoveryError = NSLocalizedString("recoveryError", tableName: "RecoveryStartFlow", comment: "")
    }
    enum RecoveryEnd {
        static let title = NSLocalizedString("title", tableName: "RecoveryEndFlow", comment: "")
        static let newPassword = NSLocalizedString("newPassword", tableName: "RecoveryEndFlow", comment: "")
        static let sign = NSLocalizedString("sign", tableName: "RecoveryEndFlow", comment: "")
    }
    enum WebView {
        static let termsAndPrivacy = NSLocalizedString("termsAndPrivacy", tableName: "WebViewFlow", comment: "")
    }
}
