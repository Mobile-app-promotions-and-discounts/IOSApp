import Foundation

protocol MainViewModelProtocol {
    var categoriesList: [Category] { get }

    func viewDidLoad()

    func getNumberOfItemsInSection(section: Int) -> Int

    func getTitleFor(indexPath: IndexPath) -> String
    func getPromotion(for index: Int) -> PromotionUIModel
    func getStore(for index: Int) -> StoreUIModel
}
