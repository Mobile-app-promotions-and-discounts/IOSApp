import UIKit
import Combine

protocol ProductReviewViewModelProtocol {
    var rating: CurrentValueSubject<Int, Never> { get }
    var reviewText: CurrentValueSubject<String, Never> { get }
    var submitReview: PassthroughSubject<(Int, String), Never> { get }
    func setupBindings()
}

class ProductReviewViewModel: ProductReviewViewModelProtocol {
     let rating = CurrentValueSubject<Int, Never>(1)
     let reviewText = CurrentValueSubject<String, Never>("")
     let submitReview = PassthroughSubject<(Int, String), Never>()

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    func setupBindings() {
        reviewText
            .sink { text in
                print(text)
            }
            .store(in: &cancellables)
    }
     // Остальные методы и логика
 }
