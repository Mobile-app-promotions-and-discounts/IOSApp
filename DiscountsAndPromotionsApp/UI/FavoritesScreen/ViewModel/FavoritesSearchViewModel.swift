import Foundation

final class FavoritesSearchResultsViewModel: SearchResultsViewModel {
    override func nextPageAction() {
        productService.getFavorites(searchItem: searchRequest,
                                    page: currentPage + 1)
    }
}
