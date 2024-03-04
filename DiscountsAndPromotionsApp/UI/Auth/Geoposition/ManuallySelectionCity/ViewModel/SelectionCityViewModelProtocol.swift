import Combine
import Foundation

protocol SelectionCityViewModelProtocol {
    var tableIsEmpty: CurrentValueSubject<Bool, Never> { get }
    var networkIsWorking: CurrentValueSubject<Bool, Never> { get }
    var isChangeCities: PassthroughSubject<Bool, Never> { get }
    var visibleCities: [CityUIModel] { get }

    func viewWillAppear()
    func viewWillDisappear()
    func findCity(_ name: String)
    func selectCity(_ tag: Int)
}
