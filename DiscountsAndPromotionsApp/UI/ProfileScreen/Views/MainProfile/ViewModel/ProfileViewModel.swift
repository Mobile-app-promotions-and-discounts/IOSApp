import Combine
import UIKit

final class ProfileViewModel: ProfileViewModelProtocol {

    var profile: CurrentValueSubject<ProfileUIModel, Never>
    private let properties = ProfilePropertyUIModel.allCases

    @Published private(set) var error: Error?

//    let networkService = UserNetworkService.shared

    var profileUpdated = Set<AnyCancellable>()

    init() {
        self.profile = CurrentValueSubject(ProfileUIModel.example)
    }

    // MARK: - Public Methods

    func viewDidLoad() {
        // getProfileData()
    }

    func viewWillAppear() {
        // подписаться на обновления
    }

    func viewWillDisapear() {
        // отписаться от обновлений
    }

    func getTableViewCount() -> Int {
        return properties.count
    }

    func getTableViewConfigure(_ index: Int) -> ProfilePropertyUIModel {
        return properties[index]
    }

    private func getProfileData() {
//        networkService.fetchUser()
    }

    func putProfileData(profile: ProfileModel) {
        /*
        guard let id = profile.id,
              let id = Int(id) else { return }
        networkService.editUser(
            [
                "phone": profile.phone ?? "",
                "foto": "https://cs5.pikabu.ru/post_img/2014/09/18/8/1411040079_1214254849.jpg",
                "first_name": profile.firstName ?? "",
                "last_name": profile.lastName ?? ""
            ],
            id: Int(id)
        )
         */
    }
}
