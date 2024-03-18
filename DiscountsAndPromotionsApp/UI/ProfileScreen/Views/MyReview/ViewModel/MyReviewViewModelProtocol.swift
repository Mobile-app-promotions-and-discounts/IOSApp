import Combine
import Foundation

protocol MyReviewViewModelProtocol {
    var title: CurrentValueSubject<String,Never> { get }
    var myReviews: CurrentValueSubject<[MyReviewUIModel], Never> { get }

    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()

    func getMyReviewsCount() -> Int
    func getMyReviewModel(index: Int) -> MyReviewUIModel
    func deleteReview(index: Int)
    func editReview(index: Int)
}
