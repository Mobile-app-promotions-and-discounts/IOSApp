import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {

    var numberOfSections: Int {
        return MainSection.allCases.count
    }

    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()
    private (set) var productsUpdate = CurrentValueSubject<[Product], Never>([])
    private (set) var storesUpdate = PassthroughSubject<[ChainStore], Never>()
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

    private var chains = [ChainStore]() {
        didSet {
            storesUpdate.send(chains)
        }
    }

    private var promotions = [Product]() {
        didSet {
            promotionsUpdate.send(promotions)
        }
    }

    private var dataService: DataServiceProtocol
    private var productService: ProductNetworkServiceProtocol
    private var storesService: StoreNetworkServiceProtocol
    private var categoryService: CategoryNetworkServiceProtocol
    private var promotionVisualService: PromotionVisualsService
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol,
         categoryService: CategoryNetworkServiceProtocol,
         prosuctService: ProductNetworkServiceProtocol,
         storesService: StoreNetworkServiceProtocol,
         promotionVisualService: PromotionVisualsService) {
        self.dataService = dataService
        self.promotionVisualService = promotionVisualService
        self.productService = prosuctService
        self.storesService = storesService
        self.categoryService = categoryService
        setupBindings()
    }

    func viewDidLoad() {
        productService.getRandomOffers()
        storesService.fetchChains()
        categoryService.fetchCategories()
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

    func getCategoryUIModel(for index: Int) -> CategoryUIModel? {
        guard index < categories.count else {
            return nil
        }
        let category = categories[index]
        return CategoryUIModel(category: category)
    }

    func getPromotion(for index: Int) -> PromotionUIModel? {
        guard index < products.count else {
            return nil
        }
        print(products[index])
        return PromotionUIModel(product: products[index],
                                visualsService: promotionVisualService)
    }

    func getStore(for index: Int) -> StoreUIModel? {
        guard index < chains.count else {
            return nil
        }
        let store = chains[index]
        return StoreUIModel(name: store.name, logo: store.logo)
    }

    func getCategory(for index: Int) -> Category? {
        guard index < categories.count else {
            return nil
        }
        let category = categories[index]
        return category
    }

    private func setupBindings() {
        productService.promotionListUpdate
            .sink { [weak self] productList in
                self?.products = productList.map { $0.convertToProductModel() }
            }
            .store(in: &cancellables)

        storesService.chainListUpdate
            .sink { [weak self] storeChainList in
                self?.chains = storeChainList.map { $0.convert() }
            }
            .store(in: &cancellables)

        dataService.actualCategoryList
            .sink { [weak self] categoryList in
                guard let self = self else { return }
                self.categories = categoryList
            }
            .store(in: &cancellables)
    }
}
