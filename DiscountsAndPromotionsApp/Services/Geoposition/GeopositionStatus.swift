import Foundation

// MARK: - AuthStatus
enum GeopositionStatus: CustomDebugStringConvertible {

    case notDetermined  // пользователь не выбрал, может ли приложение использовать службы оперделения местоположения
    case restricted // Приложению не разрешено использовать определения местоположения
    case denied // Пользователь запретил приложению исспользовать службы определения местоположения или они отключены глоабально в настройках
    case authorizedWhenInUse // пользователь разрешил запускать службы определения местоположения во время его использоватния

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
