import UIKit

struct EditReviewUImodel {
    let id: Int
    var rating: Int
    var comment: String
    var image: UIImage

    static let example = EditReviewUImodel(id: 2,
                                           rating: 3,
                                           comment: "Цена качество норм, но есть варинты получше",
                                           image: UIImage(resource: .productImagePlaceholder))
}
