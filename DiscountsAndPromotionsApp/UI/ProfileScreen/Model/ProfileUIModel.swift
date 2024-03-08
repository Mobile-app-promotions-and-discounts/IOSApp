import Combine
import Foundation

struct ProfileUIModel {
    var avatar: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    let email: String
    var birthdate: String?
    var gender: GenderModel

    static let example = ProfileUIModel(
        avatar: "https://mews.biggeek.ru/wp-content/uploads/2020/06/sidjb3splvissqug-1536x798.jpg",
        firstName: "Timothy",
        lastName: "Cook",
        phone: "+79009001020",
        email: "imbigBoss@apple.com",
        birthdate: "01.06.1960",
        gender: .man)
}
