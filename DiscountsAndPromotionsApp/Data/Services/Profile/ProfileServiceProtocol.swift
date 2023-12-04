import Foundation
import Combine

protocol ProfileServiceProtocol {
    var updatedProfile: PassthroughSubject<Profile, Never> { get }

    func getFavorites() -> [Product]?
    func addFavorite(_ product: Product)
    func removeFavorite(_ product: Product)

    func isFavorite(_ product: Product) -> Bool
}
