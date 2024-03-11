import Foundation

enum GenderModel: CaseIterable {
    case man
    case woman
    case notChoosen

    var label: String {
        switch self {
        case .man:
            L10n.Profile.Edit.Gender.man
        case .woman:
            L10n.Profile.Edit.Gender.woman
        case .notChoosen:
            L10n.Profile.Edit.Gender.notChoosen
        }
    }

    var responseName: String {
        switch self {
        case .man:
            "MAN"
        case .woman:
            "WOMAN"
        case .notChoosen:
            ""
        }
    }

    init(stringName: String?) {
        guard let stringName else {
            self = GenderModel.notChoosen
            return
        }
        switch stringName.uppercased() {
        case "MAN".uppercased():
            self = GenderModel.man
        case "WOMAN".uppercased():
            self = GenderModel.woman
        default:
            self = GenderModel.notChoosen
        }
    }

}
