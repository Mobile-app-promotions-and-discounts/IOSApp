import Foundation
import Combine

protocol CategoryViewModelProtocol {
    var productsUpdate: PassthroughSubject<[Product], Never> { get }

    func numberOfItems() -> Int
    func getProduct(for index: Int) -> ProductCellUIModel

    func likeButtonTapped(for productID: UUID)
}
