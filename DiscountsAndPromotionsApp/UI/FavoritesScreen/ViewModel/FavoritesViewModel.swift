import Foundation
import Combine

final class FavoritesViewModel: ProductListViewModel {
    override func getTitle() -> String {
        return NSLocalizedString("Favorites", tableName: "FavoritesFlow", comment: "")
    }

    override func nextPageAction() {
        productService.getFavorites(searchItem: nil,
                                   page: currentPage + 1)
    }

}
