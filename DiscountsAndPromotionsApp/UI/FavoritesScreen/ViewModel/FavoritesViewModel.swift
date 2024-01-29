import Foundation
import Combine

final class FavoritesViewModel: ProductListViewModel {
    override func getTitle() -> String {
        return "Результаты поиска"
    }

    override func nextPageAction() {
        productService.getFavorites(searchItem: nil,
                                   page: currentPage + 1)
    }

    override func updateFavoriteStatus(productID: Int, isFavorite: Bool) {
        guard !isFavorite else { return }
            if let index = products.firstIndex(where: { $0.id == productID }) {
                removeProduct(at: index)
            }
    }
}
