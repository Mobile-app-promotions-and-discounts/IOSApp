import Combine
import UIKit

protocol RatingViewViewModelProtocol {
    var reviewsButtonTapped: PassthroughSubject<Void, Never> { get }
    var rating: Double { get }
    var numberOfReviews: Int { get }
}

class RatingViewViewModel: RatingViewViewModelProtocol {
    let reviewsButtonTapped = PassthroughSubject<Void, Never>()
    var rating: Double
    var numberOfReviews: Int

    init(rating: Double, numberOfReviews: Int) {
        self.rating = rating
        self.numberOfReviews = numberOfReviews
    }
}
