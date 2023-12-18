import UIKit

final class CustomSegmentedControl: UISegmentedControl {
    private let segmentInset: CGFloat = 8
    private let segmentImage: UIImage? = UIImage(color: UIColor.cherryMainAccent)

    override func layoutSubviews() {
        super.layoutSubviews()
        // background
        layer.cornerRadius = bounds.height/2
        // foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }
}
