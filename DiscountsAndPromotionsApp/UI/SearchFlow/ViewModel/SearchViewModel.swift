import Combine
import Foundation

protocol SearchViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var categories: [Category] { get }
}

class SearchViewModel: SearchViewModelProtocol {
    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()

    private var dataService: DataServiceProtocol
    private let productService: ProductNetworkServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    private (set) var categories = [Category]() {
        didSet {
            categoriesUpdate.send(categories)
        }
    }

    init(dataService: DataServiceProtocol, productService: ProductNetworkServiceProtocol) {
        self.dataService = dataService
        self.productService = productService
        setupBindings()
    }

    func getSearchCategory(for index: Int) -> SearchCategory {
        let category = categories[index]
        return SearchCategory(rawValue: category.name) ?? SearchCategory.groceries
    }

    func getCategory(for index: Int) -> Category? {
        if index < categories.count {
            let category = categories[index]
            return category
        } else {
            return nil
        }
    }

    private func setupBindings() {
        dataService.actualCategoryList
            .sink { [weak self] categoryList in
                guard let self = self else { return }
                self.categories = categoryList
            }
            .store(in: &subscriptions)
    }
}
