import Combine
import Foundation

protocol EditReviewViewModelProtocol {
    var model: EditReviewUImodel { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var isChange: CurrentValueSubject<Bool, Never> { get }

    func editReview()
    func editRating(_ newRating: Int)
    func editComment(_ text: String)
}
