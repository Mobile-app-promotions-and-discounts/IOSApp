import UIKit

// Группы ошибок - стоит дополнять по мере развития приложения.
enum AppError: Error, Equatable {
    case authError
    case networkError(code: Int?)
    case parsingError
    case barcodeScanError
    case locationError
    case profileError(String)
    case customError(String)
    case authorizationError
    case registrationError
}

final class ErrorHandler {
    static func handle(error: AppError) {
        print("Ошибка: \(error)")
        showAlert(title: NSLocalizedString("error", tableName: "ErrorHandler", comment: ""),
                  message: message(for: error))
    }

    private static func message(for error: AppError) -> String {
        switch error {
        case .authError:
            return NSLocalizedString("authError", tableName: "ErrorHandler", comment: "")
        case .networkError:
            return NSLocalizedString("networkError", tableName: "ErrorHandler", comment: "")
        case .parsingError:
            return NSLocalizedString("parsingError", tableName: "ErrorHandler", comment: "")
        case .barcodeScanError:
            return NSLocalizedString("barcodeScanError", tableName: "ErrorHandler", comment: "")
        case .locationError:
            return NSLocalizedString("locationError", tableName: "ErrorHandler", comment: "")
        case .profileError(let error):
            return error
        case .customError(let message):
            return message
        case .authorizationError:
            return L10n.Authorization.authorizationError
        case .registrationError:
            return L10n.Registration.registrationErrorTitle
        }
    }

    private static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            UIViewController.topMostViewController()?.present(alert, animated: true)
        }
    }
}
