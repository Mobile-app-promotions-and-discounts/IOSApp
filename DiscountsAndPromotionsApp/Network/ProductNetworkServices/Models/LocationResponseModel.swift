import Foundation

struct LocationResponseModel: Codable {
   let id: Int
   let region, city, street, building: String?
}
