import UIKit

 enum ProfilePropertyUIModel: CaseIterable {
    case region
    case myReview
    case notification
    case support
    case aboutApp

    var name: String {
        switch self {
        case .region:
            NSLocalizedString("Region", tableName: "ProfileFlow", comment: "")
        case .myReview:
            NSLocalizedString("MyReviews", tableName: "ProfileFlow", comment: "")
        case .notification:
            NSLocalizedString("Notifications", tableName: "ProfileFlow", comment: "")
        case .support:
            NSLocalizedString("Support", tableName: "ProfileFlow", comment: "")
        case .aboutApp:
            NSLocalizedString("About", tableName: "ProfileFlow", comment: "")
        }
    }

    var image: UIImage? {
        switch self {
        case .region:
                .buttonRegion
        case .myReview:
                .buttonReviews
        case .notification:
                .buttonNotification
        case .support:
                .buttonSupport
        case .aboutApp:
                .buttonAbout
        }
    }

    var comment: String? {
        switch self {
        case .region:
                "Москва"
        default:
            nil
        }
    }
 }
