import Foundation
import Combine

final class AllStoresViewModel: AllStoresViewModelProtocol {

    private (set) var storesUpdate = PassthroughSubject<[Store], Never>()

    private var stores = [Store]() {
        didSet {
            storesUpdate.send(stores)
        }
    }

    private var dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        setupBindings()
    }

    func getNumberOfItems() -> Int {
        return stores.count
    }

    func getTitle() -> String {
        return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
    }

    func getStore(for index: Int) -> StoreUIModel {
        let store = stores[index]
        return StoreUIModel(store: store)
    }

    private func setupBindings() {
        dataService.actualStoreList
            .sink { [weak self] storeList in
                guard let self = self else { return }
                self.stores = storeList
            }
            .store(in: &cancellables)
    }
}
