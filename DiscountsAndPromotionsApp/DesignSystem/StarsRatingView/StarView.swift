import UIKit

final class StarView: UIImageView {
    let id: Int
    var isActive: Bool = false {
        didSet {
            image = isActive ? UIImage.icStarFill : UIImage.icStar
        }
    }

    init(id: Int) {
        self.id = id
        super.init(image: UIImage.icStar, highlightedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
