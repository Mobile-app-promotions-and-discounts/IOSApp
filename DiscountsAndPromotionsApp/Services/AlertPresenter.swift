import UIKit

final class AlertPresenter {
    static func showAlert(title: String,
                          message: String?,
                          textButton: String,
                          handler: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action1 = UIAlertAction(title: L10n.Profile.Main.cansel,
                                       style: .default)

            let action2 = UIAlertAction(title: textButton,
                                        style: .destructive) { _ in handler() }
            alert.addAction(action1)
            alert.addAction(action2)

            UIViewController.topMostViewController()?.present(alert, animated: true)
        }
    }
}
