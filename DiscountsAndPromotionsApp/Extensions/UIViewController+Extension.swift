import UIKit

extension UIViewController {
    // Метод для нахождения самого верхнего контроллера,
    // для показа на нем аллерта системы обработки ошибок ErrorHandler

    static func topMostViewController() -> UIViewController? {
        // Получаем активную сцену
        guard let activeScene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else {
            return nil
        }

        // Находим rootViewController для активной сцены
        var topController = activeScene.windows.first(where: { $0.isKeyWindow })?.rootViewController

        // Ищем верхний контроллер
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }

        return topController
    }
}
