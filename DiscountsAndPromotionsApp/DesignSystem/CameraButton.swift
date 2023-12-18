import UIKit

final class CameraButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.backgroundColor = .cherryLightBlue
        self.layer.cornerRadius = CornerRadius.regular.cgFloat()
        self.layer.masksToBounds = true
        self.setTitleColor(.cherryBlue, for: .normal)
        self.titleLabel?.font = CherryFonts.headerMedium
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.cherryGrayBlue.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
