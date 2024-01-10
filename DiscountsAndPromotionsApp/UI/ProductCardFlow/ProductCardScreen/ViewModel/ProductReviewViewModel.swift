import UIKit
import Combine

protocol ProductReviewViewModelProtocol {
    var rating: CurrentValueSubject<Int, Never> { get }
    var reviewText: CurrentValueSubject<String, Never> { get }
    var submitReview: PassthroughSubject<(Int, String), Never> { get }
    var productName: String { get }
    func setupBindings()
}

final class ProductReviewViewModel: ProductReviewViewModelProtocol {
    let rating = CurrentValueSubject<Int, Never>(1)
    let reviewText = CurrentValueSubject<String, Never>("")
    let submitReview = PassthroughSubject<(Int, String), Never>()
    var productName: String

    private var cancellables = Set<AnyCancellable>()

    init(productName: String) {
        self.productName = productName
        setupBindings()
    }

    func setupBindings() {
        reviewText
            .sink { text in
                print(text)
            }
            .store(in: &cancellables)
    }
 }
