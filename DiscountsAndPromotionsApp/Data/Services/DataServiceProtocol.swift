import Foundation
import Combine

protocol DataServiceProtocol {
    func getCategoriesList() -> AnyPublisher<[Category], Never>
    func getProductsList() -> AnyPublisher<[Product], Never>
    func getStoresList() -> AnyPublisher<[Store], Never>
}
