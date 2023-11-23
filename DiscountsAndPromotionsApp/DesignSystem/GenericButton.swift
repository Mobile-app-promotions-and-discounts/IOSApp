import UIKit

class GenericButton: UIButton {

    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isSelected ? .tintColor : .systemBackground
        titleLabel?.textColor = isSelected ? .systemBackground : .tintColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
