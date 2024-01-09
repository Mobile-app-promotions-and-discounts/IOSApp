import UIKit
import Combine

// Структура для визуальных атрибутов категории при создании Акций
struct CategoryVisualAttributes {
    var accentColor: UIColor
    var gradient: CAGradientLayer
}

// Сервис для управления визуальными атрибутами категорий
final class PromotionVisualsService {
    private var categoryList: [Category] = []
    private var visualsDict: [Int: CategoryVisualAttributes] = [:]

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
                    accentColor: .gradientOrange,
                    gradient: createGradient(colors: [.gradientBase, .gradientOrange])
                )
            case "Дом и сад":
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientBlue,
                    gradient: createGradient(colors: [.gradientBase, .gradientBlue])
                )
            case "Косметика и гигиена":
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientPurple,
                    gradient: createGradient(colors: [.gradientBase, .gradientPurple])
                )
            case "Зоотовары":
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientGreen,
                    gradient: createGradient(colors: [.gradientBase, .gradientGreen])
                )
            case "Праздник":
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientRed,
                    gradient: createGradient(colors: [.gradientBase, .gradientRed])
                )
            case "Авто":
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientYellow,
                    gradient: createGradient(colors: [.gradientBase, .gradientYellow])
                )
            default:
                visualAttributes = CategoryVisualAttributes(
                    accentColor: .gradientBlue,
                    gradient: createGradient(colors: [.gradientBase, .gradientBlue])
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
