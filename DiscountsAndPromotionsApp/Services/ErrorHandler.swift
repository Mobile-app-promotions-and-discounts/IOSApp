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
    case registrationError
    case locationSettingError
}

struct CancellationError: Error {

}

final class ErrorHandler {
    static func handle(error: AppError, handler: (() -> Void)? = nil) {
        print("Ошибка: \(error)")
        showAlert(title: NSLocalizedString("error", tableName: "ErrorHandler", comment: ""),
                  message: message(for: error),
                  handler: handler)
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
        case .registrationError:
            return NSLocalizedString("registrationError", tableName: "ErrorHandler", comment: "")
        case .locationSettingError:
            return NSLocalizedString("locationSettingError", tableName: "ErrorHandler", comment: "")
        }
    }

    private static func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let handler = handler {
                    handler()
                }
            }))

            UIViewController.topMostViewController()?.present(alert, animated: true)
        }
    }
}
