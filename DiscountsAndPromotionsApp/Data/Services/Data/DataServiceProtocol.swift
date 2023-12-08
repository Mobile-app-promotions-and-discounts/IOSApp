import Foundation
import Combine

protocol DataServiceProtocol {
    var actualGoodsList: CurrentValueSubject<[Product], Never> { get }
    var actualCategoryList: CurrentValueSubject<[Category], Never> { get }
    var actualStoreList: CurrentValueSubject<[Store], Never> { get }
    var promotionList: CurrentValueSubject<[Promotion], Never> { get }

    func loadData()
}
