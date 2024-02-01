import Combine
import Foundation

class SearchResultsViewModel: ProductListViewModel {
    private (set) var searchRequest = ""

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
