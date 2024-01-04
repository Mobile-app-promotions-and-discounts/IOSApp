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

//    func convert() -> Discount {
//        return Discount(discountRate: <#T##Int#>,
//                        discountUnit: <#T##Int#>,
//                        discountRating: <#T##Int#>,
//                        discountStart: <#T##Date#>,
//                        discountEnd: <#T##Date#>,
//                        discountCard: <#T##Bool#>)
//    }
}
