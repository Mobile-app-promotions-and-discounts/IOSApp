import Combine
import Foundation

final class EditReviewViewModel: EditReviewViewModelProtocol {

    // MARK: - Public properties
    private(set) var model: CurrentValueSubject<EditReviewUImodel, Never>
    private(set) var isLoading: CurrentValueSubject<Bool, Never>
    private(set) var isChange: CurrentValueSubject<Bool, Never>

    // MARK: - Private properties
    private let myReviewService: MyReviewServiceProtocol
    private let netModel: MyReviewNetModel?
    private let canselable = Set<AnyCancellable>()

    // MARK: - Lifecicle
    init(id: Int, myReviewService: MyReviewServiceProtocol) {
        self.isLoading = myReviewService.isLoading
        self.isChange = CurrentValueSubject(false)
        self.myReviewService = myReviewService
        self.netModel = myReviewService.myReviews.value.first(where: {$0.id == id})
//        let uiModel = EditReviewUImodel(id: netModel?.id ?? 0,
//                                        rating: netModel?.score ?? 0,
//                                        comment: netModel?.text ?? "")
        self.model = CurrentValueSubject(EditReviewUImodel.example)
    }

    // MARK: - Public methods
    func editReview() {
//        myReviewService.editReview(changeParametres(), id: model.value.id)
    }

    // MARK: - Private methods
    private func modelIsChange() {
        if netModel?.score == model.value.rating,
           netModel?.text == model.value.comment {
            isChange.send(true)
        } else {
            isChange.send(false)
        }
    }

    private func changeParametres() -> [String: Any] {
        var parametres = [String: Any]()
        if netModel?.score == model.value.rating {
            parametres["score"] = model.value.rating
        }
        if netModel?.text == model.value.comment {
            parametres["text"] = model.value.comment
        }
        return parametres
    }

}
