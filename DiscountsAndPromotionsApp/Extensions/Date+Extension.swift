import Foundation

extension Date {
    static let uiDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static let backendDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()

    static func convertFromString(_ dateString: String) -> Date? {
        return Date.backendDateFormatter.date(from: dateString)
    }

    func customFormatted() -> String {
        return Date.uiDateFormatter.string(from: self)
    }
}
