import Foundation
import Combine

protocol FavoritesViewModelProtocol {
    var favoriteProductsUpdate: PassthroughSubject<[Product], Never> { get }

    func numberOfItems() -> Int
    func getProduct(for index: Int) -> ProductCellUIModel
    func getTitleForHeader() -> String
    func getProductById(_ id: UUID) -> Product?

    func likeButtonTapped(for productID: UUID)
}
