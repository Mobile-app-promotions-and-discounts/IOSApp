import Combine
import Foundation

protocol ProductNetworkServiceProtocol {
    var productListUpdate: PassthroughSubject<ProductGroupResponseModel, Never> { get }
    var productUpdate: PassthroughSubject<ProductResponseModel, Never> { get }

    func getProducts(categoryID: Int, page: Int)
    func getProduct(productID: Int)
}

final class ProductNetworkService: ProductNetworkServiceProtocol {
    private var networkClient: NetworkClientProtocol
    private var subscriptions = Set<AnyCancellable>()

    private (set) var productListUpdate = PassthroughSubject<ProductGroupResponseModel, Never>()
    private (set) var productUpdate = PassthroughSubject<ProductResponseModel, Never>()

    private var product = ProductResponseModel(id: 0,
                                               name: nil,
                                               rating: nil,
                                               category: nil,
                                               description: nil,
                                               mainImage: "",
                                               barcode: "",
                                               stores: [],
                                               isFavorited: false) {
        didSet {
            productUpdate.send(product)
        }
    }
    private var productList = [ProductResponseModel]() {
        didSet {
            productListUpdate.send(productList)
        }
    }

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getProducts(categoryID: Int, page: Int) {
        let parameters = [
            "category": categoryID,
            "page": page
        ]

        let publisher: AnyPublisher<ProductGroupResponseModel, AppError> = networkClient.request(
            endpoint: .getCategoryProducts,
            additionalPath: "?" + parameters.queryString,
            headers: nil,
            parameters: nil
        )

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] productList in
            self?.productList = productList.sorted { $0.name ?? "" < $1.name ?? "" }
            print(self?.productList)
        }
        .store(in: &subscriptions)
    }

    func getProduct(productID: Int) {
        let publisher: AnyPublisher<ProductResponseModel, AppError> = networkClient.request(
            endpoint: .getProduct,
            additionalPath: "\(productID)",
            headers: nil,
            parameters: nil
        )

        publisher
            .sink { completion in
            switch completion {
            case .finished:
                print("Request completed successfully")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        } receiveValue: { [weak self] product in
            self?.product = product
            print(product)
        }
        .store(in: &subscriptions)
    }
}
