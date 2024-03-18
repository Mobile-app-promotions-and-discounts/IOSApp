import Combine
import Foundation

final class MyReviewViewModel: MyReviewViewModelProtocol {

    // MARK: - Public properties
    var title: CurrentValueSubject<String, Never>
    var myReviews: CurrentValueSubject<[MyReviewUIModel], Never>

    // MARK: - Private properties
    private let name = L10n.Profile.Main.Property.myReview
    private var canselable = Set<AnyCancellable>()

    init() {
        self.title = CurrentValueSubject(name)
        self.myReviews = CurrentValueSubject(MyReviewUIModel.examples)
    }

    // MARK: - Public methods
    func viewDidLoad() {
        fetchReviews()
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
        //
    }

    func editReview(index: Int) {
        //
    }

    // MARK: - Private methods
    private func bindingOn() {
        // подписаться на обновления сервера
    }

    private func bindingOff() {
        canselable.removeAll()
    }

    private func fetchReviews() {
        // запрос на сервер
    }

    private func deleteReviews() {
        // запрос на удаление с сервера
    }

    private func editReview() {
        // запрос на редактирование на сервер
    }

}
