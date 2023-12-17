import Combine
import Foundation

protocol CategoryNetworkServiceProtocol {
    var categoryListUpdate: PassthroughSubject<CategoriesResponseModel, Never> { get }

    func fetchCategories()
}
//
// final class CategoryNetworkService: CategoryNetworkServiceProtocol {
//    private var networkClient: NetworkClientProtocol
//    private var subscriptions = Set<AnyCancellable>()
//
//    private (set) var categoryListUpdate = PassthroughSubject<CategoriesResponseModel, Never>()
//    private var categoryList = [CategoryResponseModel]() {
//        didSet {
//            categoryListUpdate.send(categoryList)
//        }
//    }
//
//    init(networkClient: NetworkClientProtocol) {
//        self.networkClient = networkClient
//    }
//
//    func fetchCategories() {
//        let publisher: AnyPublisher<CategoriesResponseModel, AppError> = networkClient.request(
//            endpoint: .getCategories,
//            additionalPath: nil,
//            headers: nil,
//            parameters: nil
//        )
//
//        publisher
//            .sink { completion in
//            switch completion {
//            case .finished:
//                print("Request completed successfully")
//            case .failure(let error):
//                print("Request failed with error: \(error)")
//            }
//        } receiveValue: { [weak self] categoryList in
//            self?.categoryList = categoryList.sorted { $0.id < $1.id }
//            print(self?.categoryList)
//        }
//        .store(in: &subscriptions)
//    }
// }
