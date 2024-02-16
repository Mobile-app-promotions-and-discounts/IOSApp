import Combine
import Foundation

final class SelectionCityViewModel: SelectionCityViewModelProtocol {

    private(set) var tableIsEmpty: CurrentValueSubject<Bool, Never>
    private(set) var networkIsWorking: CurrentValueSubject<Bool, Never>
    private(set) var isChangeCities: PassthroughSubject<Bool, Never>
    private(set) var visibleCities: [CityUIModel] {
        didSet {
            isChangeCities.send(true)
            tableIsEmpty.send(visibleCities.isEmpty)
        }
    }

    private let authService: AuthServiceProtocol
    private var cities: [CityUIModel] = CityUIModel.examples

    init(authService: AuthServiceProtocol) {
        self.tableIsEmpty = CurrentValueSubject(false)
        self.networkIsWorking = CurrentValueSubject(false)
        self.isChangeCities = PassthroughSubject<Bool, Never>()
        self.visibleCities = cities
        self.authService = authService
    }

    func viewWillAppear() {
        bindingOn()
    }

    func viewWillDisappear() {
        bindingOff()
    }

    func findCity(_ name: String) {
        let filterText = name.lowercased()
        if !filterText.isEmpty {
            visibleCities = cities.filter {
                $0.name.lowercased().contains(filterText) || $0.country.lowercased().contains(filterText)
            }
        } else {
            visibleCities = cities
        }
    }

    func selectCity(_ tag: Int) {
        // TODO: отправить запрос на сервер с выбранным городом
        print("Выбран город \(visibleCities[tag].name)")
    }

    private func bindingOn() {
        // TODO:  связать данные с сетью
    }

    private func bindingOff() {
        // TODO: отвязать данные от сети
    }

    private func fetchCities() {
        // TODO: запросить данные из сети
    }

}
