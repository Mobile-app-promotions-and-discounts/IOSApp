import Combine
import Foundation

protocol ProductNetworkServiceProtocol {
    var productListUpdate: PassthroughSubject<ProductGroupResponseModel, Never> { get }
    var productUpdate: PassthroughSubject<ProductResponseModel, Never> { get }
    var isFavoriteUpdate: PassthroughSubject<Bool, Never> { get }

    var reviewListUpdate: PassthroughSubject<ProductReviews, Never> { get }
    var didPostNewReviewUpdate: PassthroughSubject<Bool, Never> { get }
    var reviewCountUpdate: PassthroughSubject<Int, Never> { get }

    var paginationPublisher: PassthroughSubject<(currentPage: Int, isLastPage: Bool), Never> { get }
    var reviewPaginationPublisher: PassthroughSubject<(currentPage: Int, isLastPage: Bool), Never> { get }

    // избранное
    func getFavorites(searchItem: String?, page: Int?)
    func addToFavorites(productID: Int)
    func removeFromFavorites(productID: Int)

    // отзывы
    func getReviewsForProduct(id productID: Int, page: Int)
    func addNewReviewForProduct(id productID: Int, review: MyProductReview)

    func getProducts(categoryID: Int?, searchItem: String?, page: Int?)
    func getProduct(productID: Int)
    func getRandomOffers()
}

actor ProductNetworkService: ProductNetworkServiceProtocol {
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol
    nonisolated private let categoryService: CategoryNetworkServiceProtocol

    nonisolated let productListUpdate = PassthroughSubject<ProductGroupResponseModel, Never>()
    nonisolated let productUpdate = PassthroughSubject<ProductResponseModel, Never>()
    nonisolated let isFavoriteUpdate = PassthroughSubject<Bool, Never>()

    nonisolated let reviewListUpdate = PassthroughSubject<ProductReviews, Never>()
    nonisolated let didPostNewReviewUpdate = PassthroughSubject<Bool, Never>()
    nonisolated let reviewCountUpdate = PassthroughSubject<Int, Never>()

    nonisolated let paginationPublisher = PassthroughSubject<(currentPage: Int, isLastPage: Bool), Never>()
    nonisolated let reviewPaginationPublisher = PassthroughSubject<(currentPage: Int, isLastPage: Bool), Never>()

    private var product = ProductResponseModel(id: 0,
                                               name: "",
                                               rating: nil,
                                               category: CategoryResponseModel(id: 0,
                                                                               priority: 0,
                                                                               name: "",
                                                                               image: nil),
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
    private var paginationState: (currentPage: Int, isLastPage: Bool) = (currentPage: 1, isLastPage: false) {
        didSet {
            paginationPublisher.send(paginationState)
        }
    }
    private var reviewPaginationState: (currentPage: Int, isLastPage: Bool) = (currentPage: 1, isLastPage: false) {
        didSet {
            reviewPaginationPublisher.send(paginationState)
        }
    }

    private var productReviews: ProductReviews = [] {
        didSet {
            reviewListUpdate.send(productReviews)
        }
    }

    private var reviewCount: Int = 0 {
        didSet {
            reviewCountUpdate.send(reviewCount)
        }
    }

    private var didPostNewReview = false {
        didSet {
            didPostNewReviewUpdate.send(didPostNewReview)
        }
    }

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared,
         categoryService: CategoryNetworkServiceProtocol) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
        self.categoryService = categoryService
        self.categoryService.fetchCategories()
    }

    // MARK: - Получение продуктов
    nonisolated func getProducts(categoryID: Int? = nil, searchItem: String? = nil, page: Int? = nil) {

        let mappedCategoryID: Int? = {
            let mappedList = categoryService.categoryListUpdate.value
            if let mappedID = mappedList.filter({ $0.priority == categoryID }).first?.id {
                return mappedID
            } else {
                return categoryID
            }
        }()

        Task { await fetchProducts(categoryID: mappedCategoryID,
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
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let productGroupResponse: PaginatedProductResponseModel = try await networkClient.request(for: urlRequest)
            print("Products fetched successfully")
            self.paginationState = (currentPage: page ?? 1,
                                    isLastPage: productGroupResponse.next == nil)
            self.productList = productGroupResponse.results
        } catch let error {
            print("Error fetching products: \(error.localizedDescription)")
            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func getRandomOffers() {
        Task { await fetchRandomOffers() }
    }

    private func fetchRandomOffers() async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getProducts,
                                                              additionalPath: "random_discounts/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let productGroupResponse: PaginatedProductResponseModel = try await networkClient.request(for: urlRequest)
            print("Random offers fetched successfully")
            self.paginationState = (currentPage: 1,
                                    isLastPage: productGroupResponse.next == nil)
            self.productList = productGroupResponse.results
        } catch let error {
            print("Error fetching offers: \(error.localizedDescription)")
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
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let productResponse: ProductResponseModel = try await networkClient.request(for: urlRequest)
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

    // MARK: - работа с избранным
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

    // MARK: - работа с отзывами
    nonisolated func getReviewsForProduct(id productID: Int, page: Int) {
        Task { await fetchReviews(productID: productID, page: page) }
    }
    private func fetchReviews(productID: Int, page: Int) async {
        var parameters: [String: Any] = [:]
        parameters.updateValue(page, forKey: "page")

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getProductReviews,
                                                              additionalPath: "\(productID)" + "/reviews/?" + parameters.queryString,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let reviewsResponse: ReviewResponse = try await networkClient.request(for: urlRequest)
            print("Reviews fetched successfully")
            print(reviewsResponse)
            self.reviewPaginationState = (currentPage: page,
                                    isLastPage: reviewsResponse.next == nil)
            self.productReviews = reviewsResponse.results
            self.reviewCount = reviewsResponse.count
        } catch let error {
            print("Error fetching reviews: \(error.localizedDescription)")
            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }

    nonisolated func addNewReviewForProduct(id productID: Int, review: MyProductReview) {
        Task { await postReview(productID: productID, review: review) }
    }
    private func postReview(productID: Int, review: MyProductReview) async {
        var newReviewParameters: [String: Any] = [:]
        newReviewParameters.updateValue(review.text, forKey: "text")
        newReviewParameters.updateValue(review.score, forKey: "score")

        guard let urlRequest = requestConstructor.makeRequest(endpoint: .postNewReview,
                                                              additionalPath: "\(productID)" + "/reviews/",
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: newReviewParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let _: URLResponse = try await networkClient.request(for: urlRequest)
            print("New review posted!")
            self.didPostNewReview = true
        } catch let error {
            print("Error posting new Review: \(error.localizedDescription)")

            self.didPostNewReview = false
            if let error = error as? AppError {
                if error == AppError.networkError(code: 422) {
                    ErrorHandler.handle(error: AppError.customError("Нельзя оставить отзыв дважды 🥺"))
                } else {
                    ErrorHandler.handle(error: error)
                }
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }
}
