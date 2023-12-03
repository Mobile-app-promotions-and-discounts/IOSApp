import UIKit

final class PrimaryButton: UIButton {
    private var initialSetup = false

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
        if !initialSetup {
            titleLabel?.textColor = .cherryWhite
            titleLabel?.font = CherryFonts.headerMedium
            layer.cornerRadius = CornerRadius.regular.cgFloat()
            clipsToBounds = true
            initialSetup = true
        }
    }

    private func setBackgroundColor() {
        if !isUserInteractionEnabled {
            backgroundColor = .cherryPrimaryDisabled
        } else {
            backgroundColor = isHighlighted ? .cherryPrimaryPressed : .cherryMainAccent
        }
    }
}
