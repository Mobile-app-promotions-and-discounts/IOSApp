import Foundation
import Combine

protocol AllStoresViewModelProtocol {
    func getNumberOfItems() -> Int
    func getTitle() -> String
    func getStore(for index: Int) -> StoreUIModel?
}
