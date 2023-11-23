import Foundation

final class CategoryViewModel: CategoryViewModelProtocol {

    private (set) var productsList = [Product]()

    func viewDidLoad() {
        self.productsList = MockDataService.shared.getProductsList()
    }

    func getNumberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return productsList.count
        default:
            return 0
        }
    }

    func getProduct(for index: Int) -> CategoryCellUIModel {
        let product = productsList[index]
        return convertModels(for: product)
    }

    private func convertModels(for product: Product) -> CategoryCellUIModel {
        return CategoryCellUIModel(product: product)
    }
}
