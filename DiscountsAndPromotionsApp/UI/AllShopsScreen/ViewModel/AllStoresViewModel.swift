import Foundation
import Combine

final class AllStoresViewModel: AllStoresViewModelProtocol {
    private var stores = [ChainStore]()

    private var storesService: StoreNetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(storesService: StoreNetworkServiceProtocol) {
        self.storesService = storesService
    }

    func getNumberOfItems() -> Int {
        return storesService.chainListUpdate.value.count
    }

    func getTitle() -> String {
        return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
    }

    func getStore(for index: Int) -> StoreUIModel? {
        guard index < storesService.chainListUpdate.value.count else { return nil }
        let store = storesService.chainListUpdate.value[index]
        return StoreUIModel(name: store.name, logo: store.logo)
    }
}
