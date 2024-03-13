import Foundation

extension String {
    static func getWordForm(_ number: Int) -> String {
        let wordForms = ["отзыв", "отзыва", "отзывов"]

        let form: String
        if number % 100 >= 11 && number % 100 <= 19 {
            form = wordForms[2]
        } else {
            switch number % 10 {
            case 1: form = wordForms[0]
            case 2...4: form = wordForms[1]
            default: form = wordForms[2]
            }
        }
        return "\(number) \(form)"
    }

    func formatPhoneNumber() -> String {
        let returnString = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask: String

        guard let numberStarts = returnString.first else { return "" }

        switch numberStarts {
        case "7":
            mask = "+#(###)###-##-##"
        case "8":
            mask = "#(###)###-##-##"
        case "9":
            mask = "+7(###)###-##-##"
        default:
            mask = "###########"
        }

        var result = ""
        var index = returnString.startIndex
        for symbol in mask where index < returnString.endIndex {
            if symbol == "#" {
                result.append(returnString[index])
                index = returnString.index(after: index)
            } else {
                result.append(symbol)
            }
        }
        return result
    }
}
