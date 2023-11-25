import Foundation

protocol CategoryViewModelProtocol {
    var productsList: [Product] { get }

    func viewDidLoad()
    func getNumberOfItemsInSection(section: Int) -> Int
    func getProduct(for index: Int) -> CategoryCellUIModel
}
