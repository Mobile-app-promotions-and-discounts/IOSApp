import Combine
import Foundation

protocol MyReviewServiceProtocol {
    var myReviews: CurrentValueSubject<[MyReviewNetModel], Never> { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }

    func fetchMyReviews()
    func deleteMyReview(id: Int)
    func editReview(_ newReviewParameters: [String: Any], id: Int)
}

actor MyReviewService: MyReviewServiceProtocol {
    nonisolated let myReviews: CurrentValueSubject<[MyReviewNetModel], Never>
    nonisolated let isLoading: CurrentValueSubject<Bool, Never>
    nonisolated static let shared = UserNetworkService(networkClient: NetworkClient())
    nonisolated private let networkClient: NetworkClientProtocol
    nonisolated private let requestConstructor: NetworkRequestConstructorProtocol

    init(networkClient: NetworkClientProtocol,
         requestConstructor: NetworkRequestConstructorProtocol = NetworkRequestConstructor.shared) {
        self.networkClient = networkClient
        self.requestConstructor = requestConstructor
        self.myReviews = CurrentValueSubject([])
        self.isLoading = CurrentValueSubject(false)
    }

    // MARK: - Получить мои отзывы
    nonisolated func fetchMyReviews() {
        isLoading.send(true)
        Task { await getMyReviews() }
    }

    private func getMyReviews() async {
        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .getMyReviews,
                                                              additionalPath: nil,
                                                              headers: headers,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }
        do {
            let reviewsModel: MyReviewsNetModel = try await networkClient.request(for: urlRequest)
            print("Get My Reviews successfully")
            myReviews.send(reviewsModel.results)
            isLoading.send(false)
        } catch let error {
            print("Error getting myReview: \(error.localizedDescription)")
            isLoading.send(false)
            networkHandler(error: error, appError: .getMyReviewsError)
        }
    }

    // MARK: - Удалить отзыв
    nonisolated func deleteMyReview(id: Int) {
        isLoading.send(true)
        Task { await requestDeleteReview(id: id) }
    }

    private func requestDeleteReview(id: Int) async {
        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .deleteMyReview,
                                                              additionalPath: "\(id)/",
                                                              headers: headers,
                                                              parameters: nil) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }
        do {
            let _: URLResponse  = try await networkClient.request(for: urlRequest)
            print("Delete my review successfully")

            let newModels = myReviews.value.filter { $0.id != id }
            myReviews.send(newModels)
            isLoading.send(false)
        } catch let error {
            print("Error delete review: \(error.localizedDescription)")
            isLoading.send(false)
            networkHandler(error: error, appError: .deleteMyReviewError)
        }
    }

    // MARK: - Отредактировать отзыв
    nonisolated func editReview(_ newReviewParameters: [String: Any], id: Int) {
        isLoading.send(true)
        Task { await requestEditReview(newReviewParameters, id: id) }
    }

    private func requestEditReview(_ newReviewParameters: [String: Any], id: Int) async {

        guard !newReviewParameters.isEmpty else { return }

        let headers = NetworkBaseConfiguration.accessTokenHeader()
        guard let urlRequest = requestConstructor.makeRequest(endpoint: .editMyReview,
                                                              additionalPath: "\(id)/",
                                                              headers: headers,
                                                              parameters: newReviewParameters) else {
            ErrorHandler.handle(error: AppError.customError("invalid request"))
            return
        }

        do {
            let reviewModel: MyReviewNetModel = try await networkClient.request(for: urlRequest)
            print("Review is edited")

            if let index = myReviews.value.firstIndex(where: {$0.id == reviewModel.id }) {
                myReviews.value[index] = reviewModel
            }
            isLoading.send(false)

        } catch let error {
            print("Review editing error: \(error.localizedDescription)")
            isLoading.send(false)

            networkHandler(error: error, appError: .editMyReviewError)
        }
    }

    private func networkHandler(error: Error, appError: AppError) {
        if error as? AppError != nil {
            ErrorHandler.handle(error: appError)
        } else {
            ErrorHandler.handle(error: AppError.customError(error.localizedDescription))
        }
    }
}
