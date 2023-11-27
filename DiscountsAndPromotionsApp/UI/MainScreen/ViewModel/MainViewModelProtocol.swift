import Foundation
import Combine

protocol MainViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var productsUpdate: PassthroughSubject<[Product], Never> { get }
    var storesUpdate: PassthroughSubject<[Store], Never> { get }
    var numberOfSections: Int { get }

    func viewDidLoad()
    func numberOfItems(inSection section: MainSection) -> Int
    func getTitleFor(indexPath: IndexPath) -> String
    func getPromotion(for index: Int) -> PromotionUIModel
    func getStore(for index: Int) -> StoreUIModel
}
