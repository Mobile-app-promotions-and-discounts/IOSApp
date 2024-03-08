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
}
