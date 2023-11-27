import UIKit

final class ProfileAssetButton: UIButton {

    // MARK: - Public properties
    var buttonImage: UIImageView = {
        let placeholder = UIImage(systemName: "photo.artframe.circle.fill")
        let buttonImage = UIImageView(image: placeholder)
        buttonImage.tintColor = .black
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        return buttonImage
    }()

    var buttonTitle: UILabel = {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.font = .boldSystemFont(ofSize: 14)
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    var buttonSubtitle: UILabel = {
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonTitleLabel.font = .systemFont(ofSize: 14)
        buttonTitleLabel.textColor = .black
        return buttonTitleLabel
    }()

    private var labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 2
        labelStack.alignment = .leading
        labelStack.isUserInteractionEnabled = false
        return labelStack
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 52).isActive = true
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
        NSLayoutConstraint.activate([
            buttonImage.heightAnchor.constraint(equalToConstant: 28),
            buttonImage.widthAnchor.constraint(equalToConstant: 28),
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }

    private func addLabels() {
        addSubview(labelStack)
        labelStack.addArrangedSubview(buttonTitle)
        labelStack.addArrangedSubview(buttonSubtitle)
//        
        labelStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelStack.leadingAnchor.constraint(equalTo: buttonImage.trailingAnchor, constant: 8).isActive = true
        labelStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
