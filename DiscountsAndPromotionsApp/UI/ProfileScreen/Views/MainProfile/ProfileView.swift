import UIKit

final class ProfileView: UIView {

    // MARK: - Private properties
    //    private let viewModel: ProfileViewModelProtocol
    private let viewController: ProfileViewController

    // MARK: - Layout elements
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.translatesAutoresizingMaskIntoConstraints = false
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
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 23
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Иван Иванов"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .black
        return nameLabel
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.text = "+ 7 (111) 111-11-11"
        phoneLabel.font = UIFont.systemFont(ofSize: 15)
        phoneLabel.textColor = .black
        return phoneLabel
    }()

    private lazy var buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .vertical
        buttonStack.spacing = 4
        return buttonStack
    }()

    private lazy var regionButton: ProfileAssetButton = {
        let regionButton = ProfileAssetButton()
        regionButton.translatesAutoresizingMaskIntoConstraints = false
        regionButton.buttonTitle.text = NSLocalizedString("Region", tableName: "ProfileFlow", comment: "")
        regionButton.buttonSubtitle.text = "Moscow"

        regionButton.backgroundColor = .buttonBG
        regionButton.addTarget(self, action: #selector(regionDidTap), for: .touchUpInside)
        return regionButton
    }()

    private lazy var reviewsButton: ProfileAssetButton = {
        let reviewsButton = ProfileAssetButton()
        reviewsButton.translatesAutoresizingMaskIntoConstraints = false
        reviewsButton.buttonTitle.text = NSLocalizedString("MyReviews", tableName: "ProfileFlow", comment: "")
        reviewsButton.backgroundColor = .buttonBG
        reviewsButton.addTarget(self, action: #selector(reviewsDidTap), for: .touchUpInside)
        return reviewsButton
    }()

    private lazy var notificationsButton: ProfileAssetButton = {
        let notificationsButton = ProfileAssetButton()
        notificationsButton.translatesAutoresizingMaskIntoConstraints = false
        notificationsButton.buttonTitle.text = NSLocalizedString("Notifications", tableName: "ProfileFlow", comment: "")
        notificationsButton.backgroundColor = .buttonBG
        notificationsButton.addTarget(self, action: #selector(notificationsDidTap), for: .touchUpInside)
        return notificationsButton
    }()

    private lazy var supportButton: ProfileAssetButton = {
        let supportButton = ProfileAssetButton()
        supportButton.translatesAutoresizingMaskIntoConstraints = false
        supportButton.buttonTitle.text = NSLocalizedString("Support", tableName: "ProfileFlow", comment: "")
        supportButton.backgroundColor = .buttonBG
        supportButton.addTarget(self, action: #selector(supportDidTap), for: .touchUpInside)
        return supportButton
    }()

    private lazy var deleteAccountButton: ProfileAssetButton = {
        let deleteAccountButton = ProfileAssetButton()
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.buttonTitle.text = NSLocalizedString("DeleteAccount", tableName: "ProfileFlow", comment: "")
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountDidTap), for: .touchUpInside)
        return deleteAccountButton
    }()

    private lazy var exitProfileButton: ProfileAssetButton = {
        let exitProfileButton = ProfileAssetButton()
        exitProfileButton.translatesAutoresizingMaskIntoConstraints = false
        exitProfileButton.buttonTitle.text = NSLocalizedString("ExitProfile", tableName: "ProfileFlow", comment: "")
        exitProfileButton.addTarget(self, action: #selector(exitAccountDidTap), for: .touchUpInside)
        return exitProfileButton
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: ProfileViewModelProtocol, viewController: ProfileViewController) {
        //        self.viewModel = viewModel
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
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 36),
            editButton.widthAnchor.constraint(equalToConstant: 36),
            editButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func addAvatar() {
        self.addSubview(avatarImage)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 46),
            avatarImage.widthAnchor.constraint(equalToConstant: 46),
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }

    private func addNameLabel() {
        self.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12).isActive = true
    }

    private func addPhoneLabel() {
        self.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
    }

    private func addButtons() {
        buttonStack.addArrangedSubview(regionButton)
        buttonStack.addArrangedSubview(reviewsButton)
        buttonStack.addArrangedSubview(notificationsButton)
        buttonStack.addArrangedSubview(supportButton)
        buttonStack.addArrangedSubview(deleteAccountButton)
        buttonStack.addArrangedSubview(exitProfileButton)

        self.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
