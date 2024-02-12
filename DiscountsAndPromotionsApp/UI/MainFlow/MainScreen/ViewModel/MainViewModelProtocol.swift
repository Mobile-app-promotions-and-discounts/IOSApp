import Foundation
import Combine

protocol MainViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var productsUpdate: CurrentValueSubject<[Product], Never> { get }
    var storesUpdate: PassthroughSubject<[ChainStore], Never> { get }
    var promotionsUpdate: PassthroughSubject<[Product], Never> { get }

    var numberOfSections: Int { get }

    func viewDidLoad()
    func numberOfItems(inSection section: MainSection) -> Int
    func getTitleFor(section: MainSection) -> String

    func getCategoryUIModel(for index: Int) -> CategoryUIModel?
    func getCategory(for index: Int) -> Category?
    func getPromotion(for idex: Int) -> PromotionUIModel?
    func getProduct(for index: Int) -> Product?
    func getStore(for index: Int) -> StoreUIModel?
}
