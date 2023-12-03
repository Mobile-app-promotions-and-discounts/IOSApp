import Foundation
import Combine

protocol DataServiceProtocol {
    var actualProductsList: CurrentValueSubject<[Product], Never> { get }
    var actualCategoryList: CurrentValueSubject<[Category], Never> { get }
    var actualStoreList: CurrentValueSubject<[Store], Never> { get }

    func loadData()
}
