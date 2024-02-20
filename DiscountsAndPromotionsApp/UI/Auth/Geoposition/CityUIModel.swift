import Foundation

struct CityUIModel {
    let name: String
    let country: String
    let id: Int

    init(name: String, country: String, id: Int) {
        self.name = name
        self.country = country
        self.id = id
    }

    init(responceModel: CityResponseModel) {
        self.name = responceModel.name
        self.country = responceModel.country
        self.id = responceModel.id
    }

    static let example = CityUIModel(name: "Москва", country: "Россия", id: 0)

    static let examples = [CityUIModel(name: "Москва", country: "Россия", id: 0),
                           CityUIModel(name: "Минск", country: "Белорусь, Минская область", id: 1),
                           CityUIModel(name: "Алматы", country: "Казахстан, Алматинская область", id: 2),
                           CityUIModel(name: "Санкт-Петербург", country: "Россия", id: 3),
                           CityUIModel(name: "Новосибирск", country: "Россия, Новосибирская область", id: 4),
                           CityUIModel(name: "Екатеринбург", country: "Россия, Свердловская область", id: 5),
                           CityUIModel(name: "Нижний Новогород",
                                       country: "Россия, Нижегородская область",
                                       id: 6),
                           CityUIModel(name: "Казань", country: "Россия, Республика Татарстан", id: 7),
                           CityUIModel(name: "Омск", country: "Россия, Омская область", id: 8),
                           CityUIModel(name: "Самара", country: "Россия, Самарская область", id: 9),
                           CityUIModel(name: "Челябинск", country: "Россия, Челябинская область", id: 10),
                           CityUIModel(name: "Уфа", country: "Россия, Руспублика Башкортостан", id: 11),
                           CityUIModel(name: "Владивосток", country: "Россия, Приморский край", id: 12),
                           CityUIModel(name: "Ташкент", country: "Узбекистан", id: 13)]
}
