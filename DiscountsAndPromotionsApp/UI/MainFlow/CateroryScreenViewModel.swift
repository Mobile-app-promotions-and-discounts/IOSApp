import Combine
import Foundation

final class CategoryScreenViewModel: ProductListViewModel {
    private let category: Category

    init(dataService: ProductNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         category: Category) {
        self.category = category

        super.init(dataService: dataService,
                   profileService: profileService)
    }

    override func getTitle() -> String {
        return NSLocalizedString(category.name, tableName: "MainFlow", comment: "")
    }

    override func nextPageAction() {
        productService.getProducts(categoryID: category.id + 1,
                                   searchItem: nil,
                                   page: currentPage + 1)
    }
}
