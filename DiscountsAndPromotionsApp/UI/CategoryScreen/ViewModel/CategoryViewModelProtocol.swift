import Foundation
import Combine

protocol CategoryViewModelProtocol {
    var productsUpdate: PassthroughSubject<[Product], Never> { get }

    func viewDidLoad()
    func numberOfItems() -> Int
    func getProduct(for index: Int) -> CategoryCellUIModel
}
