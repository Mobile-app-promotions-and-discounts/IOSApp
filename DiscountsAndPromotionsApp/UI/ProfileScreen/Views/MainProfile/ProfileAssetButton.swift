import UIKit
import SnapKit

final class ProfileAssetButton: UIButton {

    // MARK: - Public properties
    var buttonImage: UIImageView = {
        let placeholder = UIImage(systemName: "photo.artframe.circle.fill")
        let buttonImage = UIImageView(image: placeholder)
        buttonImage.tintColor = .black
        return buttonImage
    }()

    var buttonTitle: UILabel = {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.font = CherryFonts.headerMedium
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    var buttonSubtitle: UILabel = {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.font = CherryFonts.textSmall
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    private var labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.isUserInteractionEnabled = false
        return labelStack
    }()

    private lazy var disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(named: "buttonDisclosure")
        return disclosureIndicator
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)

        snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        self.backgroundColor = .cherryWhite
        layer.cornerRadius = 10

        addButtonImage()
        addLabels()
        addDisclosureIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    func removeImages() {
        self.backgroundColor = nil
        self.buttonImage.image = nil
        self.disclosureIndicator.image = nil
        labelStack.snp.remakeConstraints { make in
            make.leading.equalTo(self).inset(12)
            make.centerY.equalTo(self)
        }
    }

    // MARK: - Private Methods
    private func addButtonImage() {
        addSubview(buttonImage)
        buttonImage.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(12)
        }
    }

    private func addLabels() {
        addSubview(labelStack)
        labelStack.addArrangedSubview(buttonTitle)
        labelStack.addArrangedSubview(buttonSubtitle)
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(buttonImage.snp.trailing).offset(4)
            make.centerY.trailing.equalTo(self)
        }
    }

    private func addDisclosureIndicator() {
        addSubview(disclosureIndicator)
        disclosureIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(12)
        }
    }
}
