import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {

    var numberOfSections: Int {
        return MainSection.allCases.count
    }

    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()
    private (set) var storesUpdate = PassthroughSubject<[Store], Never>()
    private (set) var promotionsUpdate = PassthroughSubject<[Product], Never>()

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

    private var promotions = [Product]() {
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
            return 8
        case .promotions:
            return 6
        case .stores:
            return 6
        }
    }

    func getTitleFor(section: MainSection) -> String {
        switch section {
        case .promotions:
            return NSLocalizedString("Promotions this week", tableName: "MainFlow", comment: "")
        case .stores:
            return NSLocalizedString("Shops", tableName: "MainFlow", comment: "")
        case .categories:
            return ""
        }
    }

    func getCategory(for index: Int) -> CategoryUIModel? {
        guard index < categories.count else {
            return nil
        }
        let category = categories[index]
        return CategoryUIModel(category: category)
    }

    func getPromotion(for index: Int) -> PromotionUIModel? {
        guard index < promotions.count else {
            return nil
        }
        let promotion = promotions[index]
        return PromotionUIModel(product: promotion, visualsService: promotionVisualService)
    }

    func getStore(for index: Int) -> StoreUIModel {
        let store = stores[index]
        return StoreUIModel(store: store)
    }

    func getCategoryID(for index: Int) -> Int {
        let category = categories[index]
        return category.id
    }

    private func setupBindings() {
        dataService.actualGoodsList
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
}
