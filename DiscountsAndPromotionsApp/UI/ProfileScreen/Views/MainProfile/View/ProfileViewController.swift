import Combine
import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var viewModel: ProfileViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Layout elements
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.tintColor = .cherryBlack
        let image = UIImage.editButton
        editButton.setImage(image, for: .normal)
        editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        return editButton
    }()

    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: .avatar)
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = Const.AvatarImage.cornerRadius
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.font = CherryFonts.headerLarge
        nameLabel.textColor = .cherryBlack
        nameLabel.textAlignment = .left
        nameLabel.isHidden = true
        return nameLabel
    }()

    private lazy var phoneNumber: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let labelsStack = UIStackView(arrangedSubviews: [nameLabel, phoneNumber])
        labelsStack.axis = .vertical
        labelsStack.spacing = Const.StackLabels.spacing
        return labelsStack
    }()

    private lazy var propertyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .orange
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var exitProfileButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.title = L10n.Profile.Main.exitProfile
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = CherryFonts.headerMedium
            return outgoing
        })
        config.baseBackgroundColor = .cherryWhite
        config.baseForegroundColor = .cherryBlack
        config.titlePadding = 12
        button.configuration = config
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(exitAccountDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.title = L10n.Profile.Main.deleteProfile
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = CherryFonts.headerMedium
            return outgoing
        })
        config.baseBackgroundColor = .cherryWhite
        config.baseForegroundColor = .cherryMainAccent
        config.titlePadding = 12
        button.configuration = config
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(deleteAccountDidTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.viewWillDisapear()
        bindingOff()
    }

    // MARK: - Private Methods - Actions
    @objc
    private func editDidTap() {
        coordinator?.navigateToEditProfileScreen()
    }

    @objc
    private func deleteAccountDidTap() {
        coordinator?.navigateToDeleteAccountScreen()
    }

    @objc
    private func exitAccountDidTap() {
        coordinator?.navigateToExitAccountScreen()
    }

    private func chooseProperty(_ model: ProfilePropertyUIModel) {
        switch model {
        case .region:
            coordinator?.navigateToRegionScreen()
        case .myReview:
            coordinator?.navigateToReviewsScreen()
        case .notification:
            coordinator?.navigateToNotificationsScreen()
        case .support:
            coordinator?.navigateToSupportScreen()
        case .aboutApp:
            coordinator?.navigateToAboutAppScreen()
        }
    }
    
    // MARK: - Private Layout Setting
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .cherryWhite
    }

    private func setupConstraints() {
        [avatarImage,
         labelsStack,
         editButton,
         propertyTableView,
         exitProfileButton,
         deleteAccountButton].forEach { view.addSubview($0) }

        avatarImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .offset(Const.AvatarImage.topOffset)
            $0.height.width.equalTo(Const.AvatarImage.widthHeight)
            $0.leading.equalToSuperview()
                .inset(Const.insetH)
        }

        labelsStack.snp.makeConstraints {
            $0.centerY.equalTo(avatarImage.snp.centerY)
            $0.leading.equalTo(avatarImage.snp.trailing)
                .offset(Const.StackLabels.leadingOffset)
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(avatarImage.snp.centerY)
            $0.height.width.equalTo(Const.AvatarImage.widthHeight)
            $0.trailing.equalToSuperview()
                .inset(Const.insetH)
        }

        propertyTableView.snp.makeConstraints {
            $0.top.equalTo(avatarImage.snp.bottom)
                .offset(Const.TableView.topOffset)
            $0.height.equalTo(260)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.insetH)
        }

        exitProfileButton.snp.makeConstraints {
            $0.top.equalTo(propertyTableView.snp.bottom)
                .offset(Const.ExitButton.topOffset)
            $0.height.equalTo(Const.ExitButton.height)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.insetH)
        }

        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(exitProfileButton.snp.bottom)
                .offset(Const.DeleteButton.topOffset)
            $0.height.equalTo(Const.DeleteButton.height)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.insetH)
        }

    }

    private func bindingOn() {
        viewModel.profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profileUIModel in
                self?.updateProfile(profileUIModel)
            }.store(in: &subscriptions)

    }

    private func updateProfile(_ profileUIModel: ProfileUIModel) {
        if let avatarString = profileUIModel.avatar {
            let url = URL(string: avatarString)
            avatarImage.kf.setImage(with: url)
        } else {
            avatarImage.image = .avatar
        }

        var text = String()
        if let name = profileUIModel.firstName {
            text = name + " "
        }
        if let lastName = profileUIModel.lastName {
            text += lastName
        }
        nameLabel.isHidden = text.isEmpty
        nameLabel.text = text.isEmpty ? "" : text

        phoneNumber.isHidden = profileUIModel.phone == nil
        phoneNumber.text = profileUIModel.phone == nil ? "" : profileUIModel.phone!
    }

    private func bindingOff() {
        subscriptions.removeAll()
    }

    private enum Const {
        static let insetH: CGFloat = 16
        enum AvatarImage {
            static let widthHeight: CGFloat = 59
            static let topOffset: CGFloat = 12
            static let cornerRadius: CGFloat = 29.5
        }
        enum StackLabels {
            static let spacing: CGFloat = 4
            static let leadingOffset: CGFloat = 8
        }
        enum EditButton {
            static let widthHeight: CGFloat = 24
        }
        enum TableView {
            static let spacing: CGFloat = 8
            static let topOffset: CGFloat = 20
        }
        enum ExitButton {
            static let topOffset: CGFloat = 20
            static let height: CGFloat = 44
        }
        enum DeleteButton {
            static let topOffset: CGFloat = 8
            static let height: CGFloat = 44
        }

    }

}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTableViewCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = propertyTableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.identifier,
            for: indexPath) as? ProfileTableViewCell
        else {
            return UITableViewCell()
        }
        let propertyModel = viewModel.getTableViewConfigure(indexPath.row)
        cell.configure(propertyModel: propertyModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = propertyTableView.cellForRow(at: indexPath) as? ProfileTableViewCell else { return }
        if let propertyModel = cell.propertyModel {
            chooseProperty(propertyModel)
        }
    }
}
