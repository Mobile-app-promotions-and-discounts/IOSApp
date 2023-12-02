import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {
    var numberOfSections: Int {
        return MainSection.allCases.count
    }

    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()
    private (set) var storesUpdate = PassthroughSubject<[Store], Never>()
    private (set) var promotionsUpdate = PassthroughSubject<[Promotion], Never>()

    private var categories = [Category]() {
        didSet {
            categoriesUpdate.send(categories)
            promotionVisualService.preparePromotionVisuals(categories)
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

    private var promotions = [Promotion]() {
        didSet {
            promotionsUpdate.send(promotions)
        }
    }

    private var dataService: DataServiceProtocol
    private var promotionVisualService: PromotionVisualsService
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol,
         promotionVisualService: PromotionVisualsService) {
        self.dataService = dataService
        self.promotionVisualService = promotionVisualService
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
            return 6
        case .stores:
            return 6
        }
    }

    func getTitleFor(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return categories[indexPath.row].name
        case 1:
            return NSLocalizedString("Promotions this week", tableName: "MainFlow", comment: "")
        case 2:
            return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
        default:
            return ""
        }
    }

    func getPromotion(for index: Int) -> PromotionUIModel? {
        guard index < promotions.count else {
            return nil
        }
        let promotion = promotions[index]
        return promotion.toUIModel(visualsService: promotionVisualService)
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

        dataService.promotionList
            .sink { [weak self] promotionList in
                guard let self = self else { return }
                self.promotions = promotionList
            }
            .store(in: &cancellables)
    }

    private func convertStoreModel(for store: Store) -> StoreUIModel {
        return StoreUIModel(store: store)
    }
}
