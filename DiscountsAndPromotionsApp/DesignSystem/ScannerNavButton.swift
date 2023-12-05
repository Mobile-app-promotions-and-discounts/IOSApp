import UIKit

class ScannerNavButton: UIButton {
    private var isSetUp = false

    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isSetUp {
            tintColor = .cherryWhite
            backgroundColor = .clear
            isSetUp = true
        }
    }
}
