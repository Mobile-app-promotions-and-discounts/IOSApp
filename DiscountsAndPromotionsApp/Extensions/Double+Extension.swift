import Foundation

extension Double {
    func customFormatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "\(self)"

        // Проверяем, есть ли дробная часть и округляем, если нужно
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return formattedNumber
        } else {
            formatter.minimumFractionDigits = 2
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
    }

    func rounded(toPlaces places:Int) -> Double {
           let divisor = pow(10.0, Double(places))
           return (self * divisor).rounded() / divisor
       }
}
