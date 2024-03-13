import UIKit

final class SignButton: UIButton {
    private var title: String

    var isShowIndicator: Bool = false {
      didSet {
        self.setNeedsUpdateConfiguration()
      }
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            self.setNeedsUpdateConfiguration()
        }
    }

    init(title: String) {
        self.title = title
        super .init(frame: .zero)
        buttonConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = CornerRadius.regular.cgFloat()
        clipsToBounds = true
    }

    private func buttonConfiguration() {
        var config = UIButton.Configuration.bordered()
        config.baseBackgroundColor = .cherryMainAccent
        config.baseForegroundColor = .cherryWhite
        config.title = title
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = CherryFonts.headerMedium
            return outgoing
        })
        self.configuration = config
        updateButtonConfiguration()
    }

    private func updateButtonConfiguration() {
        self.configurationUpdateHandler = { [unowned self] _ in
            var config = self.configuration
            config?.showsActivityIndicator = self.isShowIndicator
            config?.baseBackgroundColor = setBackgroundColor()
            self.configuration = config
        }
    }

    private func setBackgroundColor() -> UIColor {
        if !isUserInteractionEnabled {
            return .cherryPrimaryDisabled
        } else {
            return isHighlighted ? .cherryPrimaryPressed : .cherryMainAccent
        }
    }

}
