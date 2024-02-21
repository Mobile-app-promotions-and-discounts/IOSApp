import Combine
import CoreLocation
import Foundation

protocol GeoposiotionServiceProtocol {
    var currentPosition: CurrentValueSubject<Geoposition?, Never> { get }
    var geopositionStatus: CurrentValueSubject<GeopositionStatus?, Never> { get }

    func setDelegate(_ delegate: CLLocationManagerDelegate)
    func requestLocationAuthorization()

    func newVisit(_ position: Geoposition)
    func changeAuthorizationStatus(_ status: GeopositionStatus?)
    func stopUpdatingLocation()
}
