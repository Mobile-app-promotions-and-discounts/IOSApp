import UIKit

class GenericButton: UIButton {

    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isSelected ? .cherryMainAccent : .systemBackground
        titleLabel?.textColor = isSelected ? .systemBackground : .cherryMainAccent
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
