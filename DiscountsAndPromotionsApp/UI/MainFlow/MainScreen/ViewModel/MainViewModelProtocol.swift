import Foundation
import Combine

protocol MainViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var productsUpdate: PassthroughSubject<[Product], Never> { get }
    var storesUpdate: PassthroughSubject<[Store], Never> { get }
    var promotionsUpdate: PassthroughSubject<[Product], Never> { get }

    var numberOfSections: Int { get }

    func viewDidLoad()
    func numberOfItems(inSection section: MainSection) -> Int
    func getTitleFor(section: MainSection) -> String

    func getCategory(for index: Int) -> CategoryUIModel?
    func getCategoryID(for index: Int) -> Int
    func getPromotion(for index: Int) -> PromotionUIModel?
    func getStore(for index: Int) -> StoreUIModel
}
