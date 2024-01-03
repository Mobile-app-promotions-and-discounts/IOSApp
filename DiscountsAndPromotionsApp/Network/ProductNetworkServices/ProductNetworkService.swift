import Combine
import Foundation

protocol ProductNetworkServiceProtocol {
    var productListUpdate: PassthroughSubject<ProductGroupResponseModel, Never> { get }
    var productUpdate: PassthroughSubject<ProductResponseModel, Never> { get }
    var isFavoriteUpdate: PassthroughSubject<Bool, Never> { get }

    func getFavorites(searchItem: String?, page: Int?)
    func addToFavorites(productID: Int)
    func removeFromFavorites(productID: Int)

    func getProducts(categoryID: Int?, searchItem: String?, page: Int?)
    func getProduct(productID: Int)
}

actor ProductNetworkService: ProductNetworkServiceProtocol {
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let productListUpdate = PassthroughSubject<ProductGroupResponseModel, Never>()
    nonisolated let productUpdate = PassthroughSubject<ProductResponseModel, Never>()
    nonisolated let isFavoriteUpdate = PassthroughSubject<Bool, Never>()

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
    nonisolated func getProducts(categoryID: Int? = nil, searchItem: String? = nil, page: Int? = nil) {
        Task { await fetchProducts(categoryID: categoryID,
                                   searchItem: searchItem,
                                   page: page) }
    }

    private func fetchProducts(categoryID: Int? = nil, searchItem: String? = nil, page: Int? = nil) async {
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

        do {
            let productGroupResponse: PaginatedProductResponseModel = try await networkClient.request(for: urlRequest)
            print(productGroupResponse)
            print("Products fetched successfully")

            self.productList = productGroupResponse.results.sorted { $0.name < $1.name }
        } catch let error {
            print("Error fetching products: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func getProduct(productID: Int) {
        Task { await fetchProduct(productID: productID) }
    }

    private func fetchProduct(productID: Int) async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getProduct,
                                                              additionalPath: "\(productID)",
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let productResponse: ProductResponseModel = try await networkClient.request(for: urlRequest)
            print(productResponse)
            print("Product fetched successfully")

            self.product = productResponse
        } catch let error {
            print("Error fetching product: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    // MARK: - Работа с избранным
    nonisolated func getFavorites(searchItem: String?, page: Int?) {
        Task { await fetchFavorites(searchItem: searchItem, page: page) }
    }

    private func fetchFavorites(searchItem: String?, page: Int?) async {
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

        do {
            let favoritesResponse: ProductGroupResponseModel = try await networkClient.request(for: urlRequest)
            print(favoritesResponse)
            print("Favorites fetched successfully")

            self.productList = favoritesResponse.sorted { $0.name < $1.name }
        } catch let error {
            print("Error fetching favorites: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func addToFavorites(productID: Int) {
        Task { await putNewFavoriteProduct(productID: productID) }
    }

    private func putNewFavoriteProduct(productID: Int) async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .addToFavorites,
                                                              additionalPath: "\(productID)" + "/favorite/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let favoriteProductResponse: URLResponse = try await networkClient.request(for: urlRequest)
            print(favoriteProductResponse)
            print("New favorite product added successfully")

            self.isFavorite = true
        } catch let error {
            print("Error adding to favorites: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func removeFromFavorites(productID: Int) {
        Task { await deleteFavorite(productID: productID) }
    }

    private func deleteFavorite(productID: Int) async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .removeFromFavorites,
                                                              additionalPath: "\(productID)" + "/favorite/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let favoriteProductResponse: URLResponse = try await networkClient.request(for: urlRequest)
            print(favoriteProductResponse)
            print("Un-favorited product fetched successfully")

            self.isFavorite = false
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
