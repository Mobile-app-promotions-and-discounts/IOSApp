import Foundation
import Combine

final class MockProfileService: ProfileServiceProtocol {

    private (set) var updatedProfile = PassthroughSubject<Profile, Never>()

    private var profile: Profile {
        didSet {
            updatedProfile.send(profile)
        }
    }

    init() {
        self.profile = Profile(id: nil,
                               avatar: "",
                               firstName: nil,
                               lastName: nil,
                               phone: nil,
                               email: "",
                               birthdate: nil,
                               gender: nil,
                               favoritesProducts: [])
    }

    func getFavorites() -> [Product]? {
        Array(profile.favoritesProducts)
    }

    func addFavorite(_ product: Product) {
        var newFavorites = profile.favoritesProducts
        newFavorites.insert(product)

        print(newFavorites.map { $0.id })

        profile = Profile(id: profile.id, avatar: profile.avatar, firstName: profile.firstName,
                          lastName: profile.lastName, phone: profile.phone, email: profile.email,
                          birthdate: profile.birthdate, gender: profile.gender,
                          favoritesProducts: newFavorites)
    }

    func removeFavorite(_ product: Product) {
        let newFavorites = profile.favoritesProducts.filter { $0.id != product.id }

        profile = Profile(id: profile.id, avatar: profile.avatar, firstName: profile.firstName,
                          lastName: profile.lastName, phone: profile.phone, email: profile.email,
                          birthdate: profile.birthdate, gender: profile.gender,
                          favoritesProducts: newFavorites)
    }

    func isFavorite(_ product: Product) -> Bool {
        let favoritesProducts = profile.favoritesProducts
        return favoritesProducts.contains(where: { $0.id == product.id })
    }
}
