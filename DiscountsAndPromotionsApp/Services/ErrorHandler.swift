import UIKit

// Группы ошибок - стоит дополнять по мере развития приложения.
enum AppError: Error {
    case networkError
    case parsingError
    case barcodeScanError
    case profileError(String)
    case customError(String)
}

final class ErrorHandler {
    static func handle(error: AppError) {
        print("Ошибка: \(error)")
        showAlert(title: NSLocalizedString("error", tableName: "ErrorHandler", comment: ""),
                  message: message(for: error))
    }

    private static func message(for error: AppError) -> String {
        switch error {
        case .networkError:
            return NSLocalizedString("networkError", tableName: "ErrorHandler", comment: "")
        case .parsingError:
            return NSLocalizedString("parsingError", tableName: "ErrorHandler", comment: "")
        case .barcodeScanError:
            return NSLocalizedString("barcodeScanError", tableName: "ErrorHandler", comment: "")
        case .profileError(let error):
            return error
        case .customError(let message):
            return message
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
