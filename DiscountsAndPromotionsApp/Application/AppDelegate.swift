import CoreLocation
import UIKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    let geopositionService = GeoposiotionService.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().barTintColor = UIColor.cherryWhite
        geopositionService.setDelegate(self)

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
        convertAndSebtToken(deviceToken: deviceToken)
    }

    // Этот метод вызывается, если произошла ошибка при попытке зарегистрировать устройство для push-уведомлений.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        ErrorHandler.handle(error: .customError("Failed to register for remote notifications: \(error)"))
    }

    private func convertAndSebtToken(deviceToken: Data) {
        // Конвертируем device token в строку и отправляем его на сервер
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // ToDo: - Здесь код для отправки token на сервер. Это обычно делается через HTTP-запрос к API сервера.
    }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {

    // отслеживает новый визит при перемещении
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        geopositionService.newVisit(Geoposition(latitude: visit.coordinate.latitude,
                                                longitude: visit.coordinate.longitude))
    }

    // получает текущее значение локации
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let visit = Geoposition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(visit)
        geopositionService.newVisit(visit)
    }

    // ошибка в получении локации
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        ErrorHandler.handle(error: AppError.locationError)
    }

    // проверка статуса доуступа к службам геолокации
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var geopositionStatus: GeopositionStatus?
        switch manager.authorizationStatus {
        case .notDetermined:
            geopositionStatus = .notDetermined
        case .restricted:
            geopositionStatus = .restricted
        case .denied:
            geopositionStatus = .denied
        case .authorizedWhenInUse:
            geopositionStatus = .authorizedWhenInUse
        default:
            geopositionStatus = nil
        }
        print(geopositionStatus)
        geopositionService.changeAuthorizationStatus(geopositionStatus)
    }

}
