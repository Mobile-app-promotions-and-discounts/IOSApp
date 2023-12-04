import Foundation
import Combine

// swiftlint:disable type_body_length
// swiftlint:disable function_body_length

final class MockDataService: DataServiceProtocol {
    private (set) var actualProductsList = CurrentValueSubject<[Product], Never>([])
    private (set) var actualCategoryList = CurrentValueSubject<[Category], Never>([])
    private (set) var actualStoreList = CurrentValueSubject<[Store], Never>([])
    private (set) var promotionList = CurrentValueSubject<[Promotion], Never>([])

    private var products: [Product] = [] {
        didSet {
            actualProductsList.send(products)
        }
    }

    private var categories: [Category] = [] {
        didSet {
            actualCategoryList.send(categories)
        }
    }

    private var stores: [Store] = [] {
        didSet {
            actualStoreList.send(stores)
        }
    }

    private var promotion: [Promotion] = [] {
        didSet {
            promotionList.send(promotion)
        }
    }

    func loadData() {
        // Заменить в дальнейшем на походы в сеть
        self.products = generateProducts()
        self.categories = generateCategories()
        self.stores = generateStores()
        self.promotion = generatePromotions()
    }

    private func generateCategories() -> [Category] {
        return [Category(name: "Продукты", image: "ProductsCategoryIcon"),
                Category(name: "Одежда и обувь", image: "ClothesAndShoesCategoryIcon"),
                Category(name: "Косметика и гигиена", image: "CosmeticsCategoryIcon"),
                Category(name: "Для детей", image: "ForKindsCategoryIcon"),
                Category(name: "Дом и сад", image: "HomeAndGardenCategoryIcon"),
                Category(name: "Зоотовары", image: "PetSuppliesCategoryIcon"),
                Category(name: "Праздник", image: "HolidayCategoryIcon"),
                Category(name: "Авто", image: "AutoCategoryIcon")]
    }

    private func generateProducts() -> [Product] {
        // Убедимся, что у нас есть категории для использования
        guard let categoryProducts = categories.first(where: { $0.name == "Продукты" }),
              let categoryClothesAndShoes = categories.first(where: { $0.name == "Одежда и обувь" }),
              let categoryCosmetics = categories.first(where: { $0.name == "Косметика и гигиена" }),
              let categoryForKids = categories.first(where: { $0.name == "Для детей" }),
              let categoryHomeAndGarden = categories.first(where: { $0.name == "Дом и сад" }),
              let categoryPetSupplies = categories.first(where: { $0.name == "Зоотовары" }),
              let categoryHoliday = categories.first(where: { $0.name == "Праздник" }),
              let categoryAuto = categories.first(where: { $0.name == "Авто" }) else {
            return []
        }

        return [Product(barcode: "",
                        name: "Томаты сливовидные",
                        description: "1 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 150,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 290,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Салат Айсберг",
                        description: "1 шт.",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 90,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 150,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Тыква Баттернат",
                        description: "3 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 40,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 100,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Капуста Брокколи",
                        description: "1 шт.",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 300,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 400,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Груша конференция",
                        description: "1 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 220,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 280,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Апельсины",
                        description: "1 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 120,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 200,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Картофель белый мытый",
                        description: "1 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 40,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 100,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))]),
                Product(barcode: "",
                        name: "Огурцы гладкие среднеплодные",
                        description: "1 кг",
                        category: categoryProducts,
                        image: nil,
                        rating: nil,
                        offers: [Offer(price: 99.99,
                                       discount: nil,
                                       store: Store(name: "Пятерочка",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Ленина",
                                                                            building: 15,
                                                                            postalIndex: 117899),
                                                    chainStore: nil)),
                                 Offer(price: 200.20,
                                       discount: nil,
                                       store: Store(name: "Дикси",
                                                    image: nil,
                                                    location: StoreLocation(region: "Москва",
                                                                            city: "Москва",
                                                                            street: "Герасимова",
                                                                            building: 10,
                                                                            postalIndex: 117099),
                                                    chainStore: nil))])]
    }

    func generateStores() -> [Store] {
        return [ Store(name: "Ашан",
                       image: StoreImage.init(mainImage: "Ashan", logoImage: "peterochka"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Герасимова",
                                               building: 10,
                                               postalIndex: 117099),
                       chainStore: nil),
                 Store(name: "Торговая сеть Апекс",
                       image: StoreImage.init(mainImage: "Apeks", logoImage: "peterochka"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Ленина",
                                               building: 15,
                                               postalIndex: 117899),
                       chainStore: nil),

                 Store(name: "М.видео",
                       image: StoreImage.init(mainImage: "MVideo", logoImage: "peterochka"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Герасимова",
                                               building: 10,
                                               postalIndex: 117099),
                       chainStore: nil),

                 Store(name: "О'КЕЙ",
                       image: StoreImage.init(mainImage: "Okei", logoImage: "okeiLogo"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Ленина",
                                               building: 15,
                                               postalIndex: 117899),
                       chainStore: nil),

                 Store(name: "Перекресток",
                       image: StoreImage.init(mainImage: "Perekrestok", logoImage: "perekrestokLogo"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Герасимова",
                                               building: 10,
                                               postalIndex: 117099),
                       chainStore: nil),

                 Store(name: "Дикси",
                       image: StoreImage.init(mainImage: "Diksi", logoImage: "diksiLogo"),
                       location: StoreLocation(region: "Москва",
                                               city: "Москва",
                                               street: "Ленина",
                                               building: 15,
                                               postalIndex: 117899),
                       chainStore: nil)
        ]
    }

    private func generatePromotions() -> [Promotion] {
        // Убедимся, что у нас есть хотя бы один магазин для каждой промоакции
        guard let store1 = stores.first(where: { $0.name == "Ашан" }),
              let store2 = stores.first(where: { $0.name == "М.видео" }),
              let store3 = stores.first(where: { $0.name == "О'КЕЙ" }),
              let store4 = stores.first(where: { $0.name == "Перекресток" }),
              let store5 = stores.first(where: { $0.name == "Дикси" }),
              let store6 = stores.first(where: { $0.name == "Торговая сеть Апекс" }) else {
            return []
        }

        // Убедимся, что у нас есть категории для промоакций
        guard let categoryProducts = categories.first(where: { $0.name == "Продукты" }),
              let categoryHome = categories.first(where: { $0.name == "Дом и сад" }),
              let categoryCosmetics = categories.first(where: { $0.name == "Косметика и гигиена" }),
              let categoryPets = categories.first(where: { $0.name == "Зоотовары" }),
              let categoryAuto = categories.first(where: { $0.name == "Авто" }),
              let categoryHoliday = categories.first(where: { $0.name == "Праздник" }) else {
            return []
        }

        // Создаём скидки для каждой категории
        let discount = Discount(discountRate: 30,
                                discountUnit: 1,
                                discountRating: 5,
                                discountStart: Date(),
                                discountEnd: Date(),
                                discountCard: true)

        return [Promotion(text: "До – 30% на продукты",
                          store: store1,
                          category: categoryProducts,
                          discount: discount),
                Promotion(text: "Бытовая химия: 1 = 2",
                          store: store2,
                          category: categoryHome,
                          discount: discount),
                Promotion(text: "Косметика со скидкой до 20%",
                          store: store3,
                          category: categoryCosmetics,
                          discount: discount),
                Promotion(text: "Уход за питомцами со скидкой",
                          store: store4,
                          category: categoryPets,
                          discount: discount),
                Promotion(text: "Аксессуары для авто со скидками",
                          store: store5,
                          category: categoryAuto,
                          discount: discount),
                Promotion(text: "Праздничные товары со скидкой",
                          store: store6,
                          category: categoryHoliday,
                          discount: discount)]
    }
}
// swiftlint:enable type_body_length
// swiftlint:enable function_body_length
