import Combine
import Foundation

final class SearchResultsViewModel: ProductListViewModel {
    private var searchRequest = ""

    init(productService: ProductNetworkServiceProtocol,
         profileService: ProfileServiceProtocol,
         searchText: String) {
        self.searchRequest = searchText

        super.init(dataService: productService)
    }

    override func getTitle() -> String {
        return "Результаты поиска"
    }

    override func nextPageAction() {
        productService.getProducts(categoryID: nil,
                                   searchItem: searchRequest,
                                   page: currentPage + 1)
    }
}
