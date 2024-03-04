import UIKit
import Combine

protocol ProductReviewViewModelProtocol {
    var rating: CurrentValueSubject<Int, Never> { get }
    var reviewText: CurrentValueSubject<String, Never> { get }
    var submitReview: PassthroughSubject<(Int, String), Never> { get }
    var didPublishReview: PassthroughSubject<Bool, Never> { get }
    var didFetchReview: PassthroughSubject<Bool, Never> { get }
    var productName: String { get }
    func fetchReviewText()
//    func bindReviewText()
}

final class ProductReviewViewModel: ProductReviewViewModelProtocol {
    private let productService: ProductNetworkServiceProtocol

    let rating = CurrentValueSubject<Int, Never>(0)
    let reviewText = CurrentValueSubject<String, Never>("")
    let submitReview = PassthroughSubject<(Int, String), Never>()

    let didPublishReview = PassthroughSubject<Bool, Never>()
    let didFetchReview = PassthroughSubject<Bool, Never>()

    let productName: String
    let productID: Int

    private var cancellables = Set<AnyCancellable>()

    init(productName: String, productID: Int, productService: ProductNetworkServiceProtocol) {
        self.productName = productName
        self.productID = productID
        self.productService = productService
        setupBindings()
    }

    func fetchReviewText() {
        // TODO: подгружать один раз из модели экрана для всех видов
        productService.getProduct(productID: productID)
    }

    private func setupBindings() {
        productService.productUpdate
            .sink { [weak self] product in
                self?.reviewText.send(product.myReview?.text ?? "")
                self?.rating.send(product.myReview?.score ?? 0)
                self?.didFetchReview.send(true)
            }
            .store(in: &cancellables)
    }
 }
