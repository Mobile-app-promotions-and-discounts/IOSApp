import Foundation
import Combine

final class ProductCardViewModel: ProductCardViewModelProtocol {
    private let productService: ProductNetworkServiceProtocol
    private let product: Product
    private var cancellables: Set<AnyCancellable> = []

    // Массив для хранения данных о секциях и ячейках
    private (set) var sectionCells: [[ProductCardCellType]] = []

    init(product: Product, productService: ProductNetworkServiceProtocol) {
        self.productService = productService
        self.product = product
        prepareSectionsAndCellsModels()
        setupBindings()
    }

    private func setupBindings() {}

    private func prepareSectionsAndCellsModels() {
        var newSectionCells: [[ProductCardCellType]] = []
        newSectionCells.append([.image(getImage()), .name(getName())])
        sectionCells = newSectionCells
    }

    private func getImage() -> ProductImageUIModel {
        return ProductImageUIModel(product: product)
    }

    private func getName() -> ProductTitleUIModel {
        return ProductTitleUIModel(product: product)
    }
}
