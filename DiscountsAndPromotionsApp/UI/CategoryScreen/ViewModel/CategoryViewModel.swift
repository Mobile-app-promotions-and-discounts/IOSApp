import Foundation
import Combine

final class CategoryViewModel: CategoryViewModelProtocol {
    private (set) var productsUpdate = PassthroughSubject<[Product], Never>()

    @Published private var products = [Product]() {
        didSet {
            productsUpdate.send(products)
        }
    }

    private var dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(dataService: DataServiceProtocol = MockDataService()) {
        self.dataService = dataService
    }

    func viewDidLoad() {
        fetchData()
    }

    func numberOfItems() -> Int {
        return products.count
    }

    func getProduct(for index: Int) -> CategoryCellUIModel {
        let product = products[index]
        return convertModels(for: product)
    }

    private func fetchData() {
        dataService.getProductsList()
            .receive(on: RunLoop.main)
            .assign(to: \.products, on: self)
            .store(in: &cancellables)
    }

    private func convertModels(for product: Product) -> CategoryCellUIModel {
        return CategoryCellUIModel(product: product)
    }
}
