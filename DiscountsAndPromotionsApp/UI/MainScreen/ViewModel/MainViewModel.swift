import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol, ObservableObject {
    var numberOfSections: Int {
        return MainSection.allCases.count
    }

    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()
    private (set) var storesUpdate = PassthroughSubject<[Store], Never>()

    @Published private var categories = [Category]() {
        didSet {
            categoriesUpdate.send(categories)
        }
    }

    @Published private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    @Published private var stores = [Store]() {
        didSet {
            storesUpdate.send(stores)
        }
    }

    private var dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol = MockDataService()) {
        self.dataService = dataService
    }

    func viewDidLoad() {
        fetchData()
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

    private func fetchData() {
        dataService.getCategoriesList()
            .receive(on: RunLoop.main)
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)

        dataService.getProductsList()
            .receive(on: RunLoop.main)
            .assign(to: \.products, on: self)
            .store(in: &cancellables)

        dataService.getStoresList()
            .receive(on: RunLoop.main)
            .assign(to: \.stores, on: self)
            .store(in: &cancellables)
    }

    private func convertPromotionModel(for product: Product) -> PromotionUIModel {
        return PromotionUIModel(product: product)
    }

    private func convertStoreModel(for store: Store) -> StoreUIModel {
        return StoreUIModel(store: store)
    }
}
