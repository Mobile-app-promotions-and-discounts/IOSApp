import UIKit
import SnapKit

final class ProfileView: UIView {

    // MARK: - Private properties
    //    private let viewModel: ProfileViewModelProtocol
    private let viewController: ProfileViewController

    // MARK: - Layout elements
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.tintColor = .cherryBlack
        let image = UIImage(named: "editButton")
        editButton.setImage(image, for: .normal)
        editButton.layer.cornerRadius = 12
        editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        return editButton
    }()

    private lazy var avatarImage: UIImageView = {
        let noImage = UIImage(named: "avatar")
        let avatarImage = UIImageView(image: noImage)
        avatarImage.layer.cornerRadius = 29
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var labelsStack: UIStackView = {
        let labelsStack = UIStackView()
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        return labelsStack
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "User Name"
        nameLabel.font = CherryFonts.headerLarge
        nameLabel.textColor = .cherryBlack
        return nameLabel
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "+ 7 (111) 111-11-11"
        phoneLabel.font = CherryFonts.textMedium
        phoneLabel.textColor = .cherryBlack
        return phoneLabel
    }()

    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 4
        return buttonStack
    }()

    private lazy var regionButton: ProfileAssetButton = {
        let regionButton = ProfileAssetButton()
        regionButton.buttonImage.image = UIImage(named: "buttonLocation")
        regionButton.buttonTitle.text = NSLocalizedString("Region", tableName: "ProfileFlow", comment: "")
        regionButton.buttonSubtitle.text = "Moscow"
        regionButton.addTarget(self, action: #selector(regionDidTap), for: .touchUpInside)
        return regionButton
    }()

    private lazy var reviewsButton: ProfileAssetButton = {
        let reviewsButton = ProfileAssetButton()
        reviewsButton.buttonImage.image = UIImage(named: "buttonReviews")
        reviewsButton.buttonTitle.text = NSLocalizedString("MyReviews", tableName: "ProfileFlow", comment: "")
        reviewsButton.addTarget(self, action: #selector(reviewsDidTap), for: .touchUpInside)
        return reviewsButton
    }()

    private lazy var notificationsButton: ProfileAssetButton = {
        let notificationsButton = ProfileAssetButton()
        notificationsButton.buttonImage.image = UIImage(named: "buttonNotification")
        notificationsButton.buttonTitle.text = NSLocalizedString("Notifications", tableName: "ProfileFlow", comment: "")
        notificationsButton.addTarget(self, action: #selector(notificationsDidTap), for: .touchUpInside)
        return notificationsButton
    }()

    private lazy var supportButton: ProfileAssetButton = {
        let supportButton = ProfileAssetButton()
        supportButton.buttonImage.image = UIImage(named: "buttonSupport")
        supportButton.buttonTitle.text = NSLocalizedString("Support", tableName: "ProfileFlow", comment: "")
        supportButton.addTarget(self, action: #selector(supportDidTap), for: .touchUpInside)
        return supportButton
    }()

    private lazy var aboutButton: ProfileAssetButton = {
        let aboutButton = ProfileAssetButton()
        aboutButton.buttonImage.image = UIImage(named: "buttonAbout")
        aboutButton.buttonTitle.text = NSLocalizedString("About", tableName: "ProfileFlow", comment: "")
        aboutButton.addTarget(self, action: #selector(supportDidTap), for: .touchUpInside)
        return aboutButton
    }()

    private lazy var padding = UIView()

    private lazy var exitProfileButton: ProfileAssetButton = {
        let exitProfileButton = ProfileAssetButton()
        exitProfileButton.removeImages()
        exitProfileButton.buttonTitle.text = NSLocalizedString("ExitProfile", tableName: "ProfileFlow", comment: "")
        exitProfileButton.addTarget(self, action: #selector(exitAccountDidTap), for: .touchUpInside)
        return exitProfileButton
    }()

    private lazy var deleteAccountButton: ProfileAssetButton = {
        let deleteAccountButton = ProfileAssetButton()
        deleteAccountButton.removeImages()
        deleteAccountButton.buttonTitle.text = NSLocalizedString("DeleteAccount", tableName: "ProfileFlow", comment: "")
        deleteAccountButton.buttonTitle.textColor = .cherryMainAccent
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountDidTap), for: .touchUpInside)
        return deleteAccountButton
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: ProfileViewModelProtocol, viewController: ProfileViewController) {
        self.viewController = viewController

        super.init(frame: .zero)

        self.backgroundColor = .cherryLightBlue

        addAvatar()
        addEditButton()
        addLabelsStack()
        addButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func updateViews(
        avatar: Data?,
        firstName: String?,
        lastName: String?,
        phone: String?
    ) {

        if let avatar = avatar {
            avatarImage.image = UIImage(data: avatar)
        }

        nameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
        phoneLabel.text = phone ?? ""
    }

    // MARK: - Private Methods
    @objc
    private func editDidTap() {
        viewController.editDidTap()
    }

    @objc
    private func regionDidTap() {
        viewController.regionDidTap()
    }

    @objc
    private func reviewsDidTap() {
        viewController.reviewsDidTap()
    }

    @objc
    func notificationsDidTap() {
        viewController.notificationsDidTap()
    }

    @objc
    func supportDidTap() {
        viewController.supportDidTap()
    }

    @objc
    func deleteAccountDidTap() {
        viewController.deleteAccountDidTap()
    }

    @objc
    func exitAccountDidTap() {
        viewController.exitAccountDidTap()
    }

    // MARK: - Layout methods
    private func addAvatar() {
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(59)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.equalTo(snp.leading).inset(16)
        }
    }

    private func addEditButton() {
        self.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(avatarImage)
            make.trailing.equalTo(self).inset(16)
        }
    }

    private func addLabelsStack() {
        self.addSubview(labelsStack)
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(phoneLabel)
        labelsStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImage.snp.trailing).offset(8)
            make.trailing.equalTo(editButton.snp.leading).inset(8)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }
    }

    private func addButtons() {
        [regionButton,
         reviewsButton,
         notificationsButton,
         supportButton,
         aboutButton,
         padding,
         exitProfileButton,
         deleteAccountButton
        ].forEach { buttonStack.addArrangedSubview($0) }

        self.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self).inset(16)
        }
        padding.snp.makeConstraints { make in
            make.height.width.equalTo(16)
        }
    }
}
