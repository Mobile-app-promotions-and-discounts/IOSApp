import UIKit

struct StoreUIModel {
    let image: String?
    let name: String
    let offersCount: Int
    let distance: Int

    // Инициализатор для преобразования Store в UI модель для отображения
    init(store: Store) {
        self.image = store.image?.mainImage
        self.name = store.name
        self.offersCount = 150 // Пока не понял откуда и как считать
        self.distance = 240 // Пока не понял откуда и как считать
    }
}
