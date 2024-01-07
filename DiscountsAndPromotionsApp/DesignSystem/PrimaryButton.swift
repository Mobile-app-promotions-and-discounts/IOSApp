import UIKit

final class PrimaryButton: UIButton {
    private var isSetUp = false

    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            layoutSubviews()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundColor()
        if !isSetUp {
            titleLabel?.textColor = .cherryWhite
            titleLabel?.font = CherryFonts.headerMedium
            layer.cornerRadius = CornerRadius.regular.cgFloat()
            clipsToBounds = true
            isSetUp = true
        }
    }

    private func setBackgroundColor() {
        if !isUserInteractionEnabled {
            backgroundColor = .cherryPrimaryDisabled
        } else if isSelected {
            backgroundColor = .cherryPrimaryDisabled
        } else {
            backgroundColor = isHighlighted ? .cherryPrimaryPressed : .cherryMainAccent
        }
    }
}
