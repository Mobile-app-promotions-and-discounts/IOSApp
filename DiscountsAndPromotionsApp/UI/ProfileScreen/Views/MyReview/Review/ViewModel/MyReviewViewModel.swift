import Combine
import Foundation

final class MyReviewViewModel: MyReviewViewModelProtocol {

    // MARK: - Public properties
    private(set) var title: CurrentValueSubject<String, Never>
    private(set) var myReviews: CurrentValueSubject<[MyReviewUIModel], Never>
    private(set) var isLoading: CurrentValueSubject<Bool, Never>

    // MARK: - Private properties
    private let name = L10n.Profile.Main.Property.myReview
    private var canselable = Set<AnyCancellable>()

    private let myReviewsService: MyReviewServiceProtocol

    init(myReviewsService: MyReviewServiceProtocol) {
        self.title = CurrentValueSubject(name)
        self.myReviews = CurrentValueSubject([])
        self.myReviewsService = myReviewsService
        self.isLoading = myReviewsService.isLoading
    }

    // MARK: - Public methods
    func fetchMyReviews() {
        myReviewsService.fetchMyReviews()
    }

    func viewWillAppear() {
        bindingOn()
    }

    func viewWillDisappear() {
        bindingOff()
    }

    func getMyReviewsCount() -> Int {
        return myReviews.value.count
    }

    func getMyReviewModel(index: Int) -> MyReviewUIModel {
        return myReviews.value[index]
    }

    func deleteReview(index: Int) {
        myReviewsService.deleteMyReview(id: index)
    }

    func editReview(index: Int) {
        let params = ["":""]
        // myReviewsService.editReview(params, id: index)
    }

    // MARK: - Private methods
    private func bindingOn() {
        myReviewsService.myReviews
            .sink { [weak self] netModels in
                guard let self else { return }
                let uiModels = netModels.compactMap { self.convertNetToUIModel(to: $0) }
                self.myReviews.send(uiModels)
                if netModels.count > 0 {
                     self.title.send(self.name + " (\(rewiewCounterString(netModels.count)))")
                }
            }.store(in: &canselable)
    }

    private func bindingOff() {
        canselable.removeAll()
    }

    private func convertNetToUIModel(to netModel: MyReviewNetModel) -> MyReviewUIModel {
        MyReviewUIModel.init(id: netModel.id,
                             name: netModel.productName,
                             comment: netModel.text,
                             rating: netModel.score,
                             imageURLString: nil) // в ответе от сервера пока нет картинки
    }

    private func rewiewCounterString(_ number: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("countOfReview", comment: "rewiew count"),
                                                number)
    }

}
