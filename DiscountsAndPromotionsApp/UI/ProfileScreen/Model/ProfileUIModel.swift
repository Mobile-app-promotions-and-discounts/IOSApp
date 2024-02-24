import Foundation

struct ProfileUIModel {
    let avatar: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String
    let birthdate: String?
    let gender: GenderModel?

    static let example = ProfileUIModel(
        avatar: "https://mews.biggeek.ru/wp-content/uploads/2020/06/sidjb3splvissqug-1536x798.jpg",
        firstName: "Timothy",
        lastName: "Cook",
        phone: "+79009001020",
        email: "imbigBoss@apple.com",
        birthdate: "01.06.1960",
        gender: .man)
}
