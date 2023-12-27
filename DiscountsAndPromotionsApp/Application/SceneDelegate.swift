import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let navigationController = GenericNavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        coordinator?.start()

        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        makeRequestForPushNotification()
    }

    private func makeRequestForPushNotification() {
        // Запрос разрешения на push-уведомления
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                // Если разрешение получено, регистрируем уведомления
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                ErrorHandler.handle(error: .customError("Ошибка получения разрешения на получение пушей"))
            }
        }

        UNUserNotificationCenter.current().delegate = self
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Обработка уведомления, когда приложение активно
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Обработка, когда пользователь взаимодействует с уведомлением (например, открывает его)
        completionHandler()
    }
}
