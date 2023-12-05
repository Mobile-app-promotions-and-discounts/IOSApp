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
        buttonTitleLabel.font = .boldSystemFont(ofSize: 14)
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    var buttonSubtitle: UILabel = {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.font = .systemFont(ofSize: 14)
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    private var labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 2
        labelStack.alignment = .leading
        labelStack.isUserInteractionEnabled = false
        return labelStack
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)

        snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        layer.cornerRadius = 10

        addButtonImage()
        addLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func addButtonImage() {
        addSubview(buttonImage)
        buttonImage.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.centerY.equalTo(self)
            make.leading.equalTo(self).inset(12)
        }
    }

    private func addLabels() {
        addSubview(labelStack)
        labelStack.addArrangedSubview(buttonTitle)
        labelStack.addArrangedSubview(buttonSubtitle)
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(buttonImage.snp.trailing).offset(8)
            make.centerY.trailing.equalTo(self)
        }
    }
}
