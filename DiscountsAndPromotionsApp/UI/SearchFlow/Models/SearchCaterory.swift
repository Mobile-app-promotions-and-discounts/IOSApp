import UIKit

enum SearchCategory: String, CaseIterable {
    case groceries = "Продукты"
    case clothes = "Одежда и обувь"
    case home = "Дом и сад"
    case cosmetics = "Косметика и гигиена"
    case children = "Для детей"
    case pets = "Зоотовары"
    case cars = "Авто"
    case party = "Праздник"

    func getIcon() -> UIImage? {
        switch self {
        case .groceries:
            return .icBag
        case .clothes:
            return .icClothes
        case .home:
            return .icCoffee
        case .cosmetics:
            return .icCosmetic
        case .children:
            return .icToy
        case .pets:
            return .icPet
        case .cars:
            return .icCar
        case .party:
            return .icCake

        default:
            return UIImage(systemName: "circle.fill")?.withTintColor(.cherryGray)
        }
    }
}
