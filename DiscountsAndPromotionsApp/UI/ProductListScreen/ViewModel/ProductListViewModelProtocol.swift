import Foundation
import Combine

protocol ProductListViewModelProtocol {
    var productsUpdate: PassthroughSubject<Int, Never> { get }
    var products: [Product] { get }
    var viewState: CurrentValueSubject<ViewState, Never> { get }

    func getProduct(for index: Int) -> ProductCellUIModel
    func getTitle() -> String
    func getProductById(_ id: Int) -> Product?
    func loadNextPage()

    func likeButtonTapped(for productID: Int)
    func didCloseScreen()
    func refresh()
}
