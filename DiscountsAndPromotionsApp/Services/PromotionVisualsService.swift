import UIKit
import Combine

// Структура для визуальных атрибутов категории при создании Акций
struct CategoryVisualAttributes {
    var gradient: CAGradientLayer
    var image: UIImage
}

// Сервис для управления визуальными атрибутами категорий
final class PromotionVisualsService {
    private var categoryList: [Category] = []
    private var visualsDict: [UUID: CategoryVisualAttributes] = [:]

    func preparePromotionVisuals(_ categories: [Category]) {
        updateVisualDict(categoryList: categories)
    }

    // Метод для получения визуальных атрибутов категории
    func visualAttributesForCategory(_ category: Category) -> CategoryVisualAttributes? {
        if let attributes = visualsDict[category.id] {
            return attributes
        } else {
            ErrorHandler.handle(error: .customError("Ошибка получения атрибутов для Акии"))
            return nil
        }
    }

    // Создаем пока моковый словарь соответствия категории и фонового градиента + картинки для Акций
    private func updateVisualDict(categoryList: [Category]) {
        // Заполняем словарь визуальными атрибутами для каждой категории
        for category in categoryList {
            let visualAttributes: CategoryVisualAttributes
            switch category.name {
            case "Продукты":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientOrange]),
                    image: .coffe
                )
            case "Дом и сад":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientBlue]),
                    image: .himiya
                )
            case "Косметика и гигиена":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientPurple]),
                    image: .cosmetica
                )
            case "Зоотовары":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientGreen]),
                    image: .animalFood
                )
            case "Праздник":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientRed]),
                    image: .gift
                )
            case "Авто":
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientYellow]),
                    image: .auto
                )
            default:
                visualAttributes = CategoryVisualAttributes(
                    gradient: createGradient(colors: [.gradientBase, .gradientBlue]),
                    image: .gift
                )
            }
            // Сохраняем визуальные атрибуты в словарь
            visualsDict[category.id] = visualAttributes
        }
    }

    // Вспомогательная функция для создания градиента
    private func createGradient(colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        return gradientLayer
    }
}
