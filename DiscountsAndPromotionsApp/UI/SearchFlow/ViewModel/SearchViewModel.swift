import Combine
import UIKit
import Foundation

protocol SearchViewModelProtocol {
    var categoriesUpdate: PassthroughSubject<[Category], Never> { get }
    var categories: [Category] { get }
}

class SearchViewModel: SearchViewModelProtocol {
    var categoriesUpdate = PassthroughSubject<[Category], Never>()

    private var categoryService: CategoryNetworkServiceProtocol
    private let productService: ProductNetworkServiceProtocol

    private (set) var categories = [Category]()

    init(categoryService: CategoryNetworkServiceProtocol, productService: ProductNetworkServiceProtocol) {
        self.categoryService = categoryService
        self.productService = productService
        self.categories = categoryService.categoryListUpdate.value.sorted { $0.priority < $1.priority }.map {
            Category(id: $0.priority, name: $0.name, image: $0.image)
        }
    }

    func getSearchCategory(for index: Int) -> SearchCategoryModel {
        let category = categories[index]
        if let searchCategory = SearchCategory(rawValue: category.name) {
            return SearchCategoryModel(icon: searchCategory.getIcon(),
                                       name: searchCategory.rawValue,
                                       id: searchCategory.getID())
        } else {
            return SearchCategoryModel(icon: UIImage(systemName: "circle.fill"),
                                       name: category.name,
                                       id: category.id)
        }
    }

    func getCategory(for index: Int) -> Category? {
        if index < categories.count {
            let category = categories[index]
            return category
        } else {
            return nil
        }
    }
}
