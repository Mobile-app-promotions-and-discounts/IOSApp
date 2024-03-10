import Foundation

struct ProfileUIModel {

    var avatar: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    let email: String
    var birthdate: String?
    var gender: GenderModel

    init(avatar: String? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         phone: String? = nil,
         email: String,
         birthdate: String? = nil,
         gender: GenderModel) {
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.birthdate = birthdate
        self.gender = gender
    }

    init(networkModel: UserResponseModel) {
        self.avatar = networkModel.photo
        self.firstName = networkModel.firstName
        self.lastName = networkModel.lastName
        self.phone = networkModel.phone
        self.email = networkModel.username
        if let dateOfBirth = networkModel.dateOfBirth {
            self.birthdate = Date.convertFromString(dateOfBirth)?.customFormatted()
        }
        self.gender = GenderModel(stringName: networkModel.gender)
    }

    func getParametres(from model: UserResponseModel) -> [String: String] {
        var params = [String:String]()
        if model.photo != avatar { params["photo"] = avatar ?? "" }
        if model.firstName != firstName { params["first_name"] = firstName ?? "" }
        if model.lastName != lastName { params["last_name"] = lastName ?? "" }
        if model.phone != phone { params["phone"] = phone ?? "" }
        // if model.username != email { params["username"] = email }
        if let dateOfBirth = model.dateOfBirth {
            if let birthdate = birthdate {
                if Date.convertFromString(dateOfBirth)?.customFormatted() != birthdate {
                    let date = Date.convertFromUIString(birthdate)
                    let dateString = date?.convertToBackendString()
                    params["date_of_birth"] = dateString
                }
            } else {
                params["date_of_birth"] = ""
            }

        }
        if model.gender != gender.responseName { params["gender"] = gender.responseName }
        return params
    }

    static let example = ProfileUIModel(
        avatar: "https://mews.biggeek.ru/wp-content/uploads/2020/06/sidjb3splvissqug-1536x798.jpg",
        firstName: "Timothy",
        lastName: "Cook",
        phone: "+79009001020",
        email: "imbigBoss@apple.com",
        birthdate: "01.06.1960",
        gender: .man)

    static let emptyModel = ProfileUIModel(email: "", gender: .notChoosen)
}
