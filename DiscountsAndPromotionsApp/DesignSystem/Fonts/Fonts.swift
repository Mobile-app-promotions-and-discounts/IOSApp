import UIKit

// Кастомные шрифты - импортированные в проект
enum Fonts {
    static let manropeBold = "Manrope Bold"
    static let manropeSemiBold = "Manrope SemiBold"
    static let manropeRegular = "Manrope Regular"
    static let caveatRegular = "Caveat Regular"
}

// Использование шрифтов
struct CherryFonts {
    static let titleExtraLarge = UIFont(name: Fonts.manropeBold, size: 27)

    static let headerExtraLarge = UIFont(name: Fonts.manropeBold, size: 24)
    static let headerLarge = UIFont(name: Fonts.manropeBold, size: 20)
    static let headerMedium = UIFont(name: Fonts.manropeBold, size: 16)
    static let headerSmall = UIFont(name: Fonts.manropeSemiBold, size: 12)

    static let textLarge  = UIFont(name: Fonts.manropeRegular, size: 24)
    static let textMedium  = UIFont(name: Fonts.manropeRegular, size: 15)
    static let textSmall  = UIFont(name: Fonts.manropeRegular, size: 12)

    static let inputSmall = UIFont(name: Fonts.manropeRegular, size: 16)

    // Текст для ЛОГО
    static let logoText = UIFont(name: Fonts.caveatRegular, size: 90)
}
