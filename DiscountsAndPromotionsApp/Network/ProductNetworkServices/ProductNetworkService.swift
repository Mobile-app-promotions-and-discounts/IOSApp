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
    private let requestConstructor: NetworkRequestConstructorProtocol
    
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
    
    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }
    
    func getProducts(categoryID: Int, page: Int) {
        let parameters = [
            "category": categoryID,
            "page": page
        ]
        
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getCategoryProducts,
                                                              additionalPath: "?" + parameters.queryString,
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }
        
        Task {
            do {
                let productGroupResponse: ProductGroupResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(productGroupResponse)
                    print("Products fetched successfully")
                    
                    guard let self else { return }
                    self.productList = productGroupResponse.sorted { $0.name ?? "" < $1.name ?? "" }
                }
            } catch let error {
                print("Error fetching products: \(error.localizedDescription)")
                
                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }
    
    func getProduct(productID: Int) {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getProduct,
                                                              additionalPath: "\(productID)",
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }
        
        Task {
            do {
                let productResponse: ProductResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(productResponse)
                    print("Product fetched successfully")
                    
                    guard let self else { return }
                    self.product = productResponse
                }
            } catch let error {
                print("Error fetching product: \(error.localizedDescription)")
                
                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }
}
