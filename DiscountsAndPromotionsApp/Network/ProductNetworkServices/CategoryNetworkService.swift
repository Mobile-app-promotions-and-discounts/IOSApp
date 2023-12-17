import Combine
import Foundation

protocol CategoryNetworkServiceProtocol {
    var categoryListUpdate: PassthroughSubject<CategoriesResponseModel, Never> { get }

    func fetchCategories()
}

final class CategoryNetworkService: CategoryNetworkServiceProtocol {
    private var networkClient: NetworkClientProtocol
    private let requestConstructor: NetworkRequestConstructorProtocol

    private (set) var categoryListUpdate = PassthroughSubject<CategoriesResponseModel, Never>()
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

    func fetchCategories() {
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getCategories,
                                                              additionalPath: nil,
                                                              headers: nil,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        Task {
            do {
                let categoriesResponse: CategoriesResponseModel = try await networkClient.request(for: urlRequest)
                await MainActor.run { [weak self] in
                    print(categoriesResponse)
                    print("Categories fetched successfully")

                    guard let self else { return }
                    self.categoryList = categoriesResponse.sorted { $0.id < $1.id }
                }
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
}
