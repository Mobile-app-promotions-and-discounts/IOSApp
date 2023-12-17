import UIKit
import Combine

protocol ProfileViewModelProtocol: AnyObject {

    var profile: ProfileModel? { get }
    var profilePublished: Published<ProfileModel?> { get }
    var profilePublisher: Published<ProfileModel?>.Publisher { get }
    var error: Error? { get }

    func getProfileData()
    func putProfileData(profile: ProfileModel)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    @Published private(set) var profile: ProfileModel?
    var profilePublished: Published<ProfileModel?> { _profile }
    var profilePublisher: Published<ProfileModel?>.Publisher { $profile }

    @Published private(set) var error: Error?

    // TODO: - после обновления сетевого слоя отказываемся от синглтонов и передаем сервис через главный координатор
    let networkService = UserNetworkService.shared

    var profileUpdated = Set<AnyCancellable>()

    init() {
        networkService.userUpdate.sink { user in
            self.profile = ProfileModel(
                id: String(user.id),
                avatar: nil,
                firstName: user.firstName,
                lastName: user.lastName,
                phone: user.phone,
                email: user.username,
                birthdate: nil,
                gender: nil
            )
        }
        .store(in: &profileUpdated)

        NotificationCenter.default
            .publisher(for: Notification.Name("updateProfile"))
            .sink { object in
                guard let profile = object.object as? ProfileModel else { return }
                self.putProfileData(profile: profile)
            }
            .store(in: &profileUpdated)
    }

    // MARK: - Public Methods
    func getProfileData() {
        networkService.fetchUser()

        // Mock functionality
//        if let storedProfile = UserDefaults.standard.data(forKey: "storedProfile") {
//            do {
//                self.profile = try JSONDecoder().decode(ProfileModel.self, from: storedProfile)
//            } catch {
//                self.error = error
//            }
//        } else {
//            self.profile = ProfileModel(
//                id: "1",
//                avatar: nil,
//                firstName: "Maxim",
//                lastName: "Agarev",
//                phone: "+79011234567",
//                email: "maximagarev@yandex.ru",
//                birthdate: "01.01.2001",
//                gender: true)
//        }
    }

    func putProfileData(profile: ProfileModel) {
        print(profile)
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

        // Mock functionality
        //        do {
        //            let profileToStore = try JSONEncoder().encode(profile)
        //            UserDefaults.standard.set(profileToStore, forKey: "storedProfile")
        //            getProfileData()
        //        } catch {
        //            self.error = error
        //        }
        //    }
    }
}
