import Combine
import UIKit

protocol RatingViewViewModelProtocol {
    var reviewsButtonTapped: PassthroughSubject<Void, Never> { get }
    var rating: Double { get }
    var reviewCountPublisher: CurrentValueSubject<Int, Never> { get }

    func setReviewCount(_ count: Int)
}

final class RatingViewViewModel: RatingViewViewModelProtocol {
    let reviewsButtonTapped = PassthroughSubject<Void, Never>()
    let reviewCountPublisher = CurrentValueSubject<Int, Never>(0)

    var rating: Double
    private var numberOfReviews: Int = 0 {
        didSet {
            reviewCountPublisher.send(numberOfReviews)
        }
    }

    init(rating: Double) {
        self.rating = rating
    }

    func setReviewCount(_ count: Int) {
        numberOfReviews = count
    }
}
