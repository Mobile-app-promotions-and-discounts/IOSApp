import UIKit

final class SectionBackgroundView: UICollectionReusableView {
    static let reuseIdentifier = "SectionBackgroundView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        backgroundColor = .cherryWhite
        layer.cornerRadius = CornerRadius.regular.cgFloat()
    }
}
