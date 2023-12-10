import Foundation

extension String {
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
