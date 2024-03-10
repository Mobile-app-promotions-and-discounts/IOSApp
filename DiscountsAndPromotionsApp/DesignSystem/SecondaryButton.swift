import UIKit

final class SecondaryButton: UIButton {
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
            titleLabel?.font = CherryFonts.headerMedium
            layer.cornerRadius = CornerRadius.regular.cgFloat()
            layer.borderWidth = 1
            clipsToBounds = true
            initialSetup = true
        }
    }

    private func setBackgroundColor() {
        if !isUserInteractionEnabled {
            backgroundColor = .cherryWhiteEmptyScreen
            titleLabel?.textColor = .cherryPrimaryDisabled
            layer.borderColor = UIColor.cherryPrimaryDisabled.cgColor
        } else {
            backgroundColor = isHighlighted ? .cherryLightBlue : .cherryWhiteEmptyScreen
            titleLabel?.textColor = .cherryMainAccent
            layer.borderColor = UIColor.cherryMainAccent.cgColor
        }
    }
}
