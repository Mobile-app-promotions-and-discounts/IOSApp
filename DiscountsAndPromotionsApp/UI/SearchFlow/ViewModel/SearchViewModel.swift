import Combine
import Foundation

protocol SearchViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var categories: [Category] { get }
}

final class SearchViewModel: SearchViewModelProtocol {
    private (set) var categoriesUpdate = PassthroughSubject<[Category], Never>()

    private var dataService: DataServiceProtocol
    private var subscriptions = Set<AnyCancellable>()

    private (set) var categories = [Category]() {
        didSet {
            categoriesUpdate.send(categories)
        }
    }

    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        setupBindings()
    }

    func getSearchCategory(for index: Int) -> SearchCategory {
        let category = categories[index]
        return SearchCategory(rawValue: category.name) ?? SearchCategory.groceries
    }

    func getCategoryID(for index: Int) -> Int? {
        if index < categories.count {
            let category = categories[index]
            return category.id
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
