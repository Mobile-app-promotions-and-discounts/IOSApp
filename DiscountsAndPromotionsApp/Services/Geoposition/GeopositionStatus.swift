import Foundation

// MARK: - AuthStatus
enum GeopositionStatus: CustomDebugStringConvertible {

    case notDetermined  // пользователь не выбрал, может ли приложение использовать службы оперделения местоположения
    case restricted // Запрещено использовать определения местоположения
    case denied // Пользователь запретил исспользовать службы геолокаци или они отключены глобально в настройках
    case authorizedWhenInUse // разрешено запускать службы геолакации во время его использования

    var debugDescription: String {
        var status = ""
        switch self {
        case .notDetermined:
            status = "notDetermined"
        case .restricted:
            status = "restricted"
        case .denied:
            status = "denied"
        case .authorizedWhenInUse:
            status = "authorizedWhenInUse"
        }
        return "GeopositionStatus = " + status
    }
}
