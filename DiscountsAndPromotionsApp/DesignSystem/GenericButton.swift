import UIKit

class GenericButton: UIButton {

    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isSelected ? .mainAccent : .systemBackground
        titleLabel?.textColor = isSelected ? .systemBackground : .mainAccent
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
