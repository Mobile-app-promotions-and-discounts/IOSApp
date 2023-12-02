import UIKit
import SnapKit

final class ProfileView: UIView {

    // MARK: - Private properties
    //    private let viewModel: ProfileViewModelProtocol
    private let viewController: ProfileViewController

    // MARK: - Layout elements
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.backgroundColor = .buttonBG
        editButton.tintColor = .black
        let image = UIImage(named: "EditButton")
        editButton.setImage(image, for: .normal)
        editButton.layer.cornerRadius = 18
        editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        return editButton
    }()

    private lazy var avatarImage: UIImageView = {
        let noImage = UIImage(systemName: "person.circle")?.withTintColor(.buttonBG, renderingMode: .alwaysOriginal)
        let avatarImage = UIImageView(image: noImage)
        avatarImage.layer.cornerRadius = 23
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Иван Иванов"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .black
        return nameLabel
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "+ 7 (111) 111-11-11"
        phoneLabel.font = UIFont.systemFont(ofSize: 15)
        phoneLabel.textColor = .black
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
        regionButton.buttonTitle.text = NSLocalizedString("Region", tableName: "ProfileFlow", comment: "")
        regionButton.buttonSubtitle.text = "Moscow"
        regionButton.backgroundColor = .buttonBG
        regionButton.addTarget(self, action: #selector(regionDidTap), for: .touchUpInside)
        return regionButton
    }()

    private lazy var reviewsButton: ProfileAssetButton = {
        let reviewsButton = ProfileAssetButton()
        reviewsButton.buttonTitle.text = NSLocalizedString("MyReviews", tableName: "ProfileFlow", comment: "")
        reviewsButton.backgroundColor = .buttonBG
        reviewsButton.addTarget(self, action: #selector(reviewsDidTap), for: .touchUpInside)
        return reviewsButton
    }()

    private lazy var notificationsButton: ProfileAssetButton = {
        let notificationsButton = ProfileAssetButton()
        notificationsButton.buttonTitle.text = NSLocalizedString("Notifications", tableName: "ProfileFlow", comment: "")
        notificationsButton.backgroundColor = .buttonBG
        notificationsButton.addTarget(self, action: #selector(notificationsDidTap), for: .touchUpInside)
        return notificationsButton
    }()

    private lazy var supportButton: ProfileAssetButton = {
        let supportButton = ProfileAssetButton()
        supportButton.buttonTitle.text = NSLocalizedString("Support", tableName: "ProfileFlow", comment: "")
        supportButton.backgroundColor = .buttonBG
        supportButton.addTarget(self, action: #selector(supportDidTap), for: .touchUpInside)
        return supportButton
    }()

    private lazy var deleteAccountButton: ProfileAssetButton = {
        let deleteAccountButton = ProfileAssetButton()
        deleteAccountButton.buttonTitle.text = NSLocalizedString("DeleteAccount", tableName: "ProfileFlow", comment: "")
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountDidTap), for: .touchUpInside)
        return deleteAccountButton
    }()

    private lazy var exitProfileButton: ProfileAssetButton = {
        let exitProfileButton = ProfileAssetButton()
        exitProfileButton.buttonTitle.text = NSLocalizedString("ExitProfile", tableName: "ProfileFlow", comment: "")
        exitProfileButton.addTarget(self, action: #selector(exitAccountDidTap), for: .touchUpInside)
        return exitProfileButton
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: ProfileViewModelProtocol, viewController: ProfileViewController) {
        self.viewController = viewController

        super.init(frame: .zero)

        self.backgroundColor = .mainBG

        addEditButton()
        addAvatar()
        addNameLabel()
        addPhoneLabel()
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
    private func addEditButton() {
        self.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(12)
            make.trailing.equalTo(snp.trailing).inset(16)
        }
    }

    private func addAvatar() {
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(46)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.equalTo(snp.leading).inset(16)
        }
    }

    private func addNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(12)
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
        }
    }

    private func addPhoneLabel() {
        self.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }

    private func addButtons() {
        [regionButton,
         reviewsButton,
         notificationsButton,
         supportButton,
         deleteAccountButton,
         exitProfileButton].forEach { buttonStack.addArrangedSubview($0) }

        self.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self).inset(16)
        }
    }
}
