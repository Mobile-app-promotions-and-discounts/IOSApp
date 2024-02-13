import Combine
import Foundation

protocol CategoryNetworkServiceProtocol {
    var categoryListUpdate: CurrentValueSubject<CategoriesResponseModel, Never> { get }

    func fetchCategories()
}

actor CategoryNetworkService: CategoryNetworkServiceProtocol {
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    nonisolated let categoryListUpdate = CurrentValueSubject<CategoriesResponseModel, Never>([])
    private var categoryList = [CategoryResponseModel]() {
        didSet {
            categoryListUpdate.send(categoryList)
        }
    }

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
    }

    nonisolated func fetchCategories() {
        Task { await requestCategories() }
    }

    func requestCategories() async {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getCategories,
                                                              additionalPath: nil,
                                                              headers: NetworkBaseConfiguration.accessTokenHeader(),
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let categoriesResponse: CategoriesResponseModel = try await networkClient.request(for: urlRequest)
            print(categoriesResponse)
            print("Categories fetched successfully")

            self.categoryList = categoriesResponse.sorted { $0.priority < $1.priority }
        } catch let error {
            print("Error fetching categories: \(error.localizedDescription)")

            if let error = error as? AppError {
                ErrorHandler.handle(error: error)
            } else {
                ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
            }
        }
    }
}
