import UIKit

// Эти enum и модель уйдут когда на сервере появится маленькое лого категории

struct SearchCategoryModel {
    let icon: UIImage?
    let name: String
    let id: Int
}

enum SearchCategory: String, CaseIterable {
    case groceries = "Продукты"
    case clothes = "Одежда и обувь"
    case home = "Для дома и сада"
    case cosmetics = "Косметика и гигиена"
    case children = "Для детей"
    case pets = "Зоотовары"
    case cars = "Авто"
    case party = "К празднику"

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
        }
    }

    func getID() -> Int {
        switch self {
        case .groceries:
            return 0
        case .clothes:
            return 1
        case .home:
            return 2
        case .cosmetics:
            return 3
        case .children:
            return 4
        case .pets:
            return 5
        case .cars:
            return 5
        case .party:
            return 7
        }
    }
}
