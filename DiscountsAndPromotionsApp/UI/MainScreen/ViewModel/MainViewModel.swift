import Foundation

final class MainViewModel: MainViewModelProtocol {

    private (set) var categoriesList = [Category]()
    private (set) var promotionList = [Product]()
    private (set) var storeList = [Store]()

    func viewDidLoad() {
        self.categoriesList = MockDataService.shared.getCategoriesList()
        self.promotionList = MockDataService.shared.getProductsList()
        self.storeList = MockDataService.shared.getStoresList()
    }

    func getNumberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return categoriesList.count
        case 1:
            return promotionList.count
        case 2:
            return storeList.count
        default:
            return 0
        }
    }

    func getTitleFor(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return categoriesList[indexPath.row].name
        case 1:
            return NSLocalizedString("Promotions", tableName: "MainFlow", comment: "")
        case 2:
            return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
        default:
            return ""
        }
    }

    func getPromotion(for index: Int) -> PromotionUIModel {
        let product = promotionList[index]
        return convertPromotionModel(for: product)
    }

    func getStore(for index: Int) -> StoreUIModel {
        let store = storeList[index]
        return convertStoreModel(for: store)
    }

    private func convertPromotionModel(for product: Product) -> PromotionUIModel {
        return PromotionUIModel(product: product)
    }

    private func convertStoreModel(for store: Store) -> StoreUIModel {
        return StoreUIModel(store: store)
    }
}
