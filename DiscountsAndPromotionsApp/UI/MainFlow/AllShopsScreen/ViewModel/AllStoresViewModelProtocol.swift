import Foundation
import Combine

protocol AllStoresViewModelProtocol {
    var storesUpdate: PassthroughSubject<[Store], Never> { get }

    func getNumberOfItems() -> Int
    func getTitle() -> String
    func getStore(for index: Int) -> StoreUIModel
}
