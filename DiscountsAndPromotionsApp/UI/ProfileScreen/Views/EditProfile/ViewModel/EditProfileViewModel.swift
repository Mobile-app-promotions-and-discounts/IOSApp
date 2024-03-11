import Combine
import Foundation

final class EditProfileViewModel: EditProfileViewModelProtocol {

    // MARK: - Public properties
    private(set) var profile: CurrentValueSubject <ProfileUIModel,Never>

    // MARK: - Private properties
    private var canselable = Set<AnyCancellable>()
    private let userNetworkService: UserNetworkServiceProtocol

    // MARK: - Init
    init(userNetworkService: UserNetworkServiceProtocol) {
        self.userNetworkService = userNetworkService
        self.profile = CurrentValueSubject(ProfileUIModel.emptyModel)
    }

    // MARK: - Public methods
    func viewWillAppear() {
        bindingOn()
    }

    func viewWillDisapear() {
        bindingOff()
    }

    func changeTextField(_ text: String?, tag: Int) {
        switch tag {
        case 0: profile.value.firstName = text
        case 1: profile.value.lastName = text
        case 2: profile.value.phone = text
        case 3: break // profile.value.email = text //Изменение email отключено
        case 4: profile.value.birthdate = text
        default: break
        }
    }

    func changeGender(_ gender: GenderModel) {
        profile.value.gender = gender
    }

    func changeProfile() {
        userNetworkService.editUser(profile.value)
    }

    // MARK: - Private methods
    private func bindingOn() {
        userNetworkService.user
            .receive(on: RunLoop.main)
            .sink { [weak self] userModel in
                let profileUIModel = ProfileUIModel(networkModel: userModel)
                self?.profile.send(profileUIModel)
            }.store(in: &canselable)
    }

    private func bindingOff() {
        canselable.removeAll()
    }

}
