import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    static let reuseIdentifier = "SectionBackgroundView"

    private var footerHeight: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.frame.size.height -= footerHeight
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        backgroundColor = .cherryWhite
        layer.cornerRadius = CornerRadius.regular.cgFloat()
    }
}
