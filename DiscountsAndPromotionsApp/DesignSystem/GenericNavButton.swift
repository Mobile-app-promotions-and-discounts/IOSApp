import UIKit

class GenericNavButton: UIButton {
    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tintColor = .cherryMainAccent
        backgroundColor = .systemBackground
        layer.cornerRadius = 22
        clipsToBounds = true
    }
}
