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
    static let titleExtraLarge = UIFont(name: Fonts.manropeBold, size: 27) ?? UIFont.systemFont(ofSize: 27,
                                                                                                weight: .bold)

    static let headerExtraLarge = UIFont(name: Fonts.manropeBold, size: 24) ?? UIFont.systemFont(ofSize: 24,
                                                                                                 weight: .bold)
    static let headerLarge = UIFont(name: Fonts.manropeBold, size: 20) ?? UIFont.systemFont(ofSize: 20,
                                                                                            weight: .bold)
    static let headerMedium = UIFont(name: Fonts.manropeBold, size: 16) ?? UIFont.systemFont(ofSize: 16,
                                                                                             weight: .bold)
    static let headerSmall = UIFont(name: Fonts.manropeSemiBold, size: 12) ?? UIFont.systemFont(ofSize: 12,
                                                                                                weight: .bold)

    static let textLarge  = UIFont(name: Fonts.manropeRegular, size: 24) ?? UIFont.systemFont(ofSize: 24,
                                                                                              weight: .regular)
    static let textMedium  = UIFont(name: Fonts.manropeRegular, size: 15) ?? UIFont.systemFont(ofSize: 15,
                                                                                               weight: .regular)
    static let textSmall  = UIFont(name: Fonts.manropeRegular, size: 12) ?? UIFont.systemFont(ofSize: 12,
                                                                                              weight: .regular)

    static let inputSmall = UIFont(name: Fonts.manropeRegular, size: 16)  ?? UIFont.systemFont(ofSize: 16,
                                                                                               weight: .regular)

    // Текст для ЛОГО
    static let logoText = UIFont(name: Fonts.caveatRegular, size: 90)  ?? UIFont.systemFont(ofSize: 90,
                                                                                            weight: .regular)
}
