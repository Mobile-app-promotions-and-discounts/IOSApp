import Foundation

struct DiscountResponseModel: Codable {
    let discountRate: Int
    let discountUnit: String
    let discountStart, discountEnd: String?
    let discountCard: Bool

    enum CodingKeys: String, CodingKey {
        case discountRate = "discount_rate"
        case discountUnit = "discount_unit"
        case discountStart = "discount_start"
        case discountEnd = "discount_end"
        case discountCard = "discount_card"
    }

    func convert() -> Discount {
        var startDate = Date()
        var endDate = Date()

        if let discountStart,
           let discountStartDate = Date.convertFromString(discountStart) {
            startDate = discountStartDate
        }

        if let discountEnd,
           let discountEndDate = Date.convertFromString(discountEnd) {
            endDate = discountEndDate
        }

        return Discount(discountRate: self.discountRate,
                        discountUnit: self.discountUnit,
                        discountRating: 0,
                        discountStart: startDate,
                        discountEnd: endDate,
                        discountCard: self.discountCard)
    }
}
