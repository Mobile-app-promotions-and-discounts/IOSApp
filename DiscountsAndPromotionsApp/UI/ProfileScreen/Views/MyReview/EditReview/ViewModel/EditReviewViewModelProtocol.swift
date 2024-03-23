import Combine
import Foundation

protocol EditReviewViewModelProtocol {
    var model: CurrentValueSubject <EditReviewUImodel,Never> { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var isChange: CurrentValueSubject<Bool, Never> { get }

    func editReview()
}
