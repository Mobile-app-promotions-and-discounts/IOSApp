import Combine
import CoreLocation
import Foundation

// MARK: - GeopositionService
final class GeoposiotionService: GeoposiotionServiceProtocol {

    static let shared = GeoposiotionService()
    private(set) var currentPosition: CurrentValueSubject<Geoposition?, Never>
    private(set) var geopositionStatus: CurrentValueSubject<GeopositionStatus?, Never>

    private var cancellables: Set<AnyCancellable>

    private let locationManager = CLLocationManager()

    init() {
        self.currentPosition = CurrentValueSubject(nil)
        self.geopositionStatus = CurrentValueSubject(nil)
        self.cancellables = Set<AnyCancellable>()
        bindingOn()
    }

    func setDelegate(_ delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
    }

    // отправляем уведомление юзеру что хотим использовать геопозицию
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func newVisit(_ position: Geoposition) {
        currentPosition.send(position)
    }

    func changeAuthorizationStatus(_ status: GeopositionStatus?) {
        geopositionStatus.send(status)
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringVisits()
    }

    // мониторинг локации при использовании устройтсва
    private func bindingOn() {
        geopositionStatus
            .receive(on: RunLoop.main)
            .sink { [ weak self] geopositionStatus in
            if geopositionStatus == .authorizedWhenInUse {
                self?.setupLocationUpdate()
            } else {
                self?.stopUpdatingLocation()
            }
        }.store(in: &cancellables)
    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    private func setupLocationUpdate() {
        locationManager.startMonitoringVisits() // функция прослушивания
        locationManager.distanceFilter = 4000 // Получаем обновление, когда местоположение меняется на n метров
        locationManager.allowsBackgroundLocationUpdates = false // Не отслеживаем локацию в фоновом режиме
        locationManager.startUpdatingLocation() // начинаем отслеживать, обновляет локацию
    }

}
