import Combine
import Foundation

protocol ProductNetworkServiceProtocol {
    var productListUpdate: PassthroughSubject<ProductGroupResponseModel, Never> { get }
    var productUpdate: PassthroughSubject<ProductResponseModel, Never> { get }
    var isFavoriteUpdate: PassthroughSubject<Bool, Never> { get }

    func getFavorites(searchItem: String?,
                      page: Int?)
    func addToFavorites(productID: Int)
    func removeFromFavorites(productID: Int)

    func getProducts(categoryID: Int?,
                     searchItem: String?,
                     page: Int?)
    func getProduct(productID: Int)
}

final class ProductNetworkService: ProductNetworkServiceProtocol {
    private var networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

    private (set) var productListUpdate = PassthroughSubject<ProductGroupResponseModel, Never>()
    private (set) var productUpdate = PassthroughSubject<ProductResponseModel, Never>()
    private (set) var isFavoriteUpdate = PassthroughSubject<Bool, Never>()

    private var product = ProductResponseModel(id: 0,
                                               name: "",
                                               rating: nil,
                                               category: CategoryResponseModel(id: 0, name: ""),
                                               description: nil,
                                               mainImage: "",
                                               barcode: "",
                                               stores: [],
                                               isFavorited: false,
                                               images: []) {
        didSet {
            productUpdate.send(product)
        }
    }
    private var productList = [ProductResponseModel]() {
        didSet {
            productListUpdate.send(productList)
        }
    }
    private var isFavorite = false {
        didSet {
            isFavoriteUpdate.send(isFavorite)
        }
    }

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    // MARK: - Получение продуктов
    func getProducts(categoryID: Int? = nil,
                     searchItem: String? = nil,
                     page: Int? = nil) {
        var parameters: [String: Any] = [:]
        if let categoryID {
            parameters.updateValue(categoryID, forKey: "category")
        }
        if let searchItem {
            parameters.updateValue(searchItem, forKey: "search")
        }
        if let page {
            parameters.updateValue(page, forKey: "page")
        }

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getProducts,
                                                              additionalPath: "?" + parameters.queryString,
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let productGroupResponse: PaginatedProductResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
//                    print(productGroupResponse)
                    print("Products fetched successfully")

                    guard let self else { return }
                    self.productList = productGroupResponse.results.sorted { $0.name < $1.name }
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

    // MARK: - Работа с избранным
    func getFavorites(searchItem: String?, page: Int?) {
        var parameters: [String: Any] = [:]
        if let searchItem {
            parameters.updateValue(searchItem, forKey: "search")
        }
        if let page {
            parameters.updateValue(page, forKey: "page")
        }

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getFavorites,
                                                              additionalPath: "?" + parameters.queryString,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let favoritesResponse: ProductGroupResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(favoritesResponse)
                    print("Favorites fetched successfully")

                    guard let self else { return }
                    self.productList = favoritesResponse.sorted { $0.name < $1.name }
                }
            } catch let error {
                print("Error fetching favorites: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    func addToFavorites(productID: Int) {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .addToFavorites,
                                                              additionalPath: "\(productID)" + "/favorite/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let favoriteProductResponse: URLResponse = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(favoriteProductResponse)
                    print("New favorite product added successfully")
                    guard let self else { return }
                        self.isFavorite = true
                }
            } catch let error {
                print("Error adding to favorites: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }

    func removeFromFavorites(productID: Int) {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .removeFromFavorites,
                                                              additionalPath: "\(productID)" + "/favorite/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let favoriteProductResponse: URLResponse = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(favoriteProductResponse)
                    print("Un-favorited product fetched successfully")

                    self?.isFavorite = false
                }
            } catch let error {
                print("Error removing from favorites: \(error.localizedDescription)")

                if let error = error as? AppError {
                    ErrorHandler.handle(error: error)
                } else {
                    ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
                }
            }
        }
    }
}
