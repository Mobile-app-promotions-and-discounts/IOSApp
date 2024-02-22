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
    let rating = CurrentValueSubject<Int, Never>(1)
    let reviewText = CurrentValueSubject<String, Never>("")
    let submitReview = PassthroughSubject<(Int, String), Never>()

    let didPublishReview = PassthroughSubject<Bool, Never>()
    let didFetchReview = PassthroughSubject<Bool, Never>()

    let productName: String

    private var cancellables = Set<AnyCancellable>()

    init(productName: String) {
        self.productName = productName
    }

    func fetchReviewText() {

    }
 }
