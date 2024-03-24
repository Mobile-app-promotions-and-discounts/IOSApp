import Combine
import Foundation

final class EditReviewViewModel: EditReviewViewModelProtocol {

    // MARK: - Public properties
    private(set) var model: EditReviewUImodel
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
        let uiModel = EditReviewUImodel(id: netModel?.id ?? 0,
                                        rating: netModel?.score ?? 0,
                                        comment: netModel?.text ?? "",
                                        image: .productImagePlaceholder)
        self.model = uiModel
    }

    // MARK: - Public methods
    func editReview() {
        myReviewService.editReview(changeParametres(), id: model.id)
    }

    func editRating(_ newRating: Int) {
        model.rating = newRating
        modelIsChange()
    }

    func editComment(_ text: String) {
        model.comment = text
        modelIsChange()
    }

    // MARK: - Private methods
    private func modelIsChange() {
        if netModel?.score != model.rating ||
           netModel?.text != model.comment {
            isChange.send(true)
        } else {
            isChange.send(false)
        }
    }

    private func changeParametres() -> [String: Any] {
        var parametres = [String: Any]()
        if netModel?.score == model.rating {
            parametres["score"] = model.rating
        }
        if netModel?.text == model.comment {
            parametres["text"] = model.comment
        }
        return parametres
    }

}
