import Foundation

final class MockDataService {
    static let shared = MockDataService()

    private init() {}

    func getCategoriesList() -> [Category] {
        let categoriesList = [Category(name: "Продукты"),
                              Category(name: "Одежда и обувь"),
                              Category(name: "Для дома и сада"),
                              Category(name: "Косметика и гигиена"),
                              Category(name: "Для детей"),
                              Category(name: "Зоотовары"),
                              Category(name: "Авто"),
                              Category(name: "К празднику")]
        return categoriesList
    }
}
