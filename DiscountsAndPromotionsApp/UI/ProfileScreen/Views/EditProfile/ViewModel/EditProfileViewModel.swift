import Combine
import Foundation

final class EditProfileViewModel: EditProfileViewModelProtocol {

    private(set) var profile: CurrentValueSubject <ProfileUIModel,Never>
    private var canselable = Set<AnyCancellable>()

    init() {
        self.profile = CurrentValueSubject(ProfileUIModel.example)
    }

    // MARK: - Public methods
    func viewDidLoad() {
        // Закгрузка из сети
    }

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
        case 3: break // profile.value.email = text
        default: break
        }
    }

    func changeGender(_ gender: GenderModel) {
        profile.value.gender = gender
    }

    // MARK: - Private methods
    private func bindingOn() {
        // связь с сервером
    }

    private func bindingOff() {
        canselable.removeAll()
    }

}
