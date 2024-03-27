import Combine
import UIKit

final class ProfileViewModel: ProfileViewModelProtocol {

    // MARK: - Public properties
    private(set) var profile: CurrentValueSubject<ProfileUIModel, Never>
    private(set) var userIsDelete: PassthroughSubject<Bool, Never>

    // MARK: - Private properties
    private let properties = ProfilePropertyUIModel.allCases
    private let userNetworkService: UserNetworkServiceProtocol
    private let authService: AuthServiceProtocol
    private var profileUpdated = Set<AnyCancellable>()

    // MARK: - Init
    init(userNetworkService: UserNetworkServiceProtocol,
         authService: AuthServiceProtocol) {
        self.userNetworkService = userNetworkService
        self.authService = authService
        self.profile = CurrentValueSubject(ProfileUIModel.example)
        self.userIsDelete = PassthroughSubject<Bool, Never>()
    }

    // MARK: - Public Method
    func viewDidLoad() {
         getProfileData()
    }

    func viewWillAppear() {
        bindingOn()
    }

    func viewWillDisapear() {
        bindingOff()
    }

    func getTableViewCount() -> Int {
        return properties.count
    }

    func getTableViewConfigure(_ index: Int) -> ProfilePropertyUIModel {
        return properties[index]
    }

    func exitAccount() {
        authService.logout()
    }

    func deleteAccount(password: String) {
        userNetworkService.deleteUser(password: password)
    }

    // MARK: - Private methods
    private func getProfileData() {
        userNetworkService.fetchUser()
    }

    private func bindingOn() {
        userNetworkService.user
            .receive(on: RunLoop.main)
            .sink { [weak self] userModel in
                let profileUIModel = ProfileUIModel(networkModel: userModel)
                self?.profile.send(profileUIModel)
            }.store(in: &profileUpdated)

        userNetworkService.userIsDelete
            .receive(on: RunLoop.main)
            .sink { [weak self] isDelete in
                self?.userIsDelete.send(isDelete)
            }.store(in: &profileUpdated)
    }

    private func bindingOff() {
        profileUpdated.removeAll()
    }

}
