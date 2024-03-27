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

    static func showAlertWithTextFiel(title: String,
                                      message: String?,
                                      placeholder: String?,
                                      textButton: String,
                                      handler: @escaping (_ text: String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = placeholder
        }

        let action1 = UIAlertAction(title: L10n.Profile.Main.cansel,
                                   style: .default)
        alertController.addAction(action1)

        let action2 = UIAlertAction(title: textButton, style: .destructive) { [weak alertController] _ in
            guard let textField = alertController?.textFields?.first,
                  let inputText = textField.text else { return }
            handler(inputText)
        }
        alertController.addAction(action2)

        UIViewController.topMostViewController()?.present(alertController, animated: true)
    }
}
