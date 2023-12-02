import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {
    var numberOfSections: Int {
        return MainSection.allCases.count
    }

    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()
    private (set) var storesUpdate = PassthroughSubject<[Store], Never>()

    private var categories = [Category]() {
        didSet {
            categoriesUpdate.send(categories)
        }
    }

    private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    private var stores = [Store]() {
        didSet {
            storesUpdate.send(stores)
        }
    }

    private var dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        setupBindings()
    }

    func viewDidLoad() {
        dataService.loadData()
    }

    func numberOfItems(inSection section: MainSection) -> Int {
        switch section {
        case .categories:
            return categories.count
        case .promotions:
            return products.count
        case .stores:
            return stores.count
        }
    }

    func getTitleFor(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return categories[indexPath.row].name
        case 1:
            return NSLocalizedString("Promotions", tableName: "MainFlow", comment: "")
        case 2:
            return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
        default:
            return ""
        }
    }

    func getPromotion(for index: Int) -> PromotionUIModel {
        let product = products[index]
        return convertPromotionModel(for: product)
    }

    func getStore(for index: Int) -> StoreUIModel {
        let store = stores[index]
        return convertStoreModel(for: store)
    }

    private func setupBindings() {
        dataService.actualProductsList
            .sink { [weak self] productsList in
                guard let self = self else { return }
                self.products = productsList
            }
            .store(in: &cancellables)

        dataService.actualCategoryList
            .sink { [weak self] categoryList in
                guard let self = self else { return }
                self.categories = categoryList
            }
            .store(in: &cancellables)

        dataService.actualStoreList
            .sink { [weak self] storeList in
                guard let self = self else { return }
                self.stores = storeList
            }
            .store(in: &cancellables)
    }

    private func convertPromotionModel(for product: Product) -> PromotionUIModel {
        return PromotionUIModel(product: product)
    }

    private func convertStoreModel(for store: Store) -> StoreUIModel {
        return StoreUIModel(store: store)
    }
}
