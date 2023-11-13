import UIKit

// Enum для безопасной загрузки и обработки отсутствующих ресурсов.
enum ImageFactory {
    static func safeImage(named name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            // Логирование ошибки или другие меры при отсутствии изображения
            print("Внимание: Отсутствует изображение с именем \(name)")
            return UIImage()
        }
        return image
    }
}

//// Пример - изображения для навигации
//enum NavigationImages {
//    static let addButton: UIImage = ImageFactory.safeImage(named: "addButton")
//    static let exitButton: UIImage = ImageFactory.safeImage(named: "exitButton")
//    static let okButton: UIImage = ImageFactory.safeImage(named: "okButton")
//}
