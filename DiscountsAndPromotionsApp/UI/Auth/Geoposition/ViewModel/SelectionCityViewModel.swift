import Combine
import Foundation

final class SelectionCityViewModel: SelectionCityViewModelProtocol {

    private(set) var tableIsEmpty: CurrentValueSubject<Bool, Never>
    private(set) var networkIsWorking: CurrentValueSubject<Bool, Never>
    private(set) var isChangeCities: PassthroughSubject<Bool, Never>
    private(set) var visibleCities: [CityModel] {
        didSet {
            isChangeCities.send(true)
            tableIsEmpty.send(visibleCities.isEmpty)
        }
    }

    private let authService: AuthServiceProtocol
    private var cities: [CityModel] = [CityModel(name: "Москва", country: "Россия"),
                                       CityModel(name: "Санкт-Петербург", country: "Россия"),
                                       CityModel(name: "Алматы", country: "Казахстан")]

    init(authService: AuthServiceProtocol) {
        self.tableIsEmpty = CurrentValueSubject(false)
        self.networkIsWorking = CurrentValueSubject(false)
        self.isChangeCities = PassthroughSubject<Bool, Never>()
        self.visibleCities = []
        self.authService = authService
    }

    func viewWillAppear() {
        visibleCities = cities
        bindingOn()
    }

    func viewWillDisappear() {
        bindingOff()
    }

    func findCity(_ name: String) {
        if name.isEmpty {
            visibleCities = cities
            return
        }
        let filterText = name.lowercased()
        visibleCities = cities.filter { $0.name.lowercased().contains(filterText) }
    }

    func selectCity(_ tag: Int) {
        // отправить запрос на сервер с выбранным городом
        print("Выбран город \(visibleCities[tag].name)")
    }

    private func bindingOn() {
        // связать данные с сетью
    }

    private func bindingOff() {
        // отвязать данные от сети
    }

    private func fetchCities() {
        // запросить данные из сети
    }

}
