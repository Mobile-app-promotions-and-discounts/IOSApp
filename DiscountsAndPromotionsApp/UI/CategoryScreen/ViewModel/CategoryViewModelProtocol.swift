import Foundation
import Combine

protocol CategoryViewModelProtocol {
    var productsUpdate: PassthroughSubject<[Product], Never> { get }
    var viewState: CurrentValueSubject<ViewState, Never> { get }

    func numberOfItems() -> Int
    func getProduct(for index: Int) -> ProductCellUIModel
    func getTitle() -> String
    func getProductById(_ id: Int) -> Product?

    func likeButtonTapped(for productID: Int)
}
