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
            L10n.Profile.Main.Property.region
        case .myReview:
            L10n.Profile.Main.Property.myReview
        case .notification:
            L10n.Profile.Main.Property.notification
        case .support:
            L10n.Profile.Main.Property.support
        case .aboutApp:
            L10n.Profile.Main.Property.aboutApp
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
