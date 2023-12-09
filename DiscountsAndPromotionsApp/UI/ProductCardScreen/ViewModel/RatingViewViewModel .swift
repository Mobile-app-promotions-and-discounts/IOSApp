import Combine
import UIKit

protocol RatingViewViewModelProtocol {
    var reviewsButtonTapped: PassthroughSubject<Void, Never> { get }
}

class RatingViewViewModel: RatingViewViewModelProtocol {
    let reviewsButtonTapped = PassthroughSubject<Void, Never>()
}
