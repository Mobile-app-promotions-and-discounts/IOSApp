import UIKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().barTintColor = UIColor.cherryWhite

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Этот метод вызывается, когда устройство успешно зарегистрировано в APNs и получен device token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Конвертируем device token в строку и отправляем его на сервер
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // ToDo: - Здесь код для отправки token на сервер. Это обычно делается через HTTP-запрос к API сервера.
    }

    // Этот метод вызывается, если произошла ошибка при попытке зарегистрировать устройство для push-уведомлений.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        ErrorHandler.handle(error: .customError("Failed to register for remote notifications: \(error)"))
    }
}
