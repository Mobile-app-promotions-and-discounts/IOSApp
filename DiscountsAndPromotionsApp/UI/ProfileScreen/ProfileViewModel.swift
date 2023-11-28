import UIKit

protocol ProfileViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onError: (() -> Void)? { get set }

    var profile: ProfileModel? { get }
    var error: Error? { get }
}

final class ProfileViewModel: ProfileViewModelProtocol {
    var onChange: (() -> Void)?
    var onError: (() -> Void)?

    private(set) var profile: ProfileModel? {
        didSet {
            onChange?()
        }
    }

    private(set) var error: Error? {
        didSet {
            onError?()
        }
    }

    // MARK: - Public Methods
    func getProfileData() {
        // Mock functionality
        if let storedProfile = UserDefaults.standard.data(forKey: "storedProfile") {
            do {
                self.profile = try JSONDecoder().decode(ProfileModel.self, from: storedProfile)
            } catch {
                self.error = error
            }
        } else {
            self.profile = ProfileModel(
                id: "1",
                avatar: nil,
                firstName: "Maxim",
                lastName: "Agarev",
                phone: "+79011234567",
                email: "maximagarev@yandex.ru",
                birthdate: "01.01.2001",
                gender: true)
        }
    }

    func putProfileData(profile: ProfileModel) {
        // Mock functionality
        do {
            let profileToStore = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(profileToStore, forKey: "storedProfile")
        } catch {
            self.error = error
        }
    }

}
