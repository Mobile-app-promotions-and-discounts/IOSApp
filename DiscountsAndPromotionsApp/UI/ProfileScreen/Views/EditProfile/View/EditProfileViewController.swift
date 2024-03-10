import AVFoundation
import Combine
import Kingfisher
import UIKit

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private let viewModel: EditProfileViewModelProtocol
    private var avatarUpdated = Set<AnyCancellable>()

    // MARK: - Layout elements
    private lazy var canselButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.Edit.cansel, for: .normal)
        button.setTitleColor(.cherryBlue, for: .normal)
        button.titleLabel?.font = CherryFonts.textLarge
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.Edit.done, for: .normal)
        button.setTitleColor(.cherryBlue, for: .normal)
        button.titleLabel?.font = CherryFonts.textLarge
        button.contentHorizontalAlignment = .trailing
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .cherryWhite
        scrollView.contentSize = contenSize
        scrollView.keyboardDismissMode = .onDrag
        let tapToScroll = UITapGestureRecognizer(target: self, action: #selector(tapToScroll))
        scrollView.addGestureRecognizer(tapToScroll)
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .cherryWhite
        return view
    }()

    private var contenSize = CGSize()

    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView(image: .avatar)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Const.AvatarStack.cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var changeAvatarLabel: UILabel = {
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.text = L10n.Profile.Edit.changeAvatar
        changeAvatarLabel.font = CherryFonts.textLarge
        changeAvatarLabel.textColor = .cherryBlue
        changeAvatarLabel.textAlignment = .center
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(changeAvatarDidTap(_:)))
        changeAvatarLabel.isUserInteractionEnabled = true
        changeAvatarLabel.addGestureRecognizer(tapAction)
        return changeAvatarLabel
    }()

    private lazy var avatarStackView: UIStackView = {
        Const.verticalStackView([ avatarImage, changeAvatarLabel ],
                                spacing: .medium,
                                fillOn: false)
    }()

    private lazy var firstNameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = L10n.Profile.Edit.firstName
        textField.font = CherryFonts.textMedium
        textField.delegate = self
        textField.tag = 0
        textField.addTarget(self, action: #selector(changeTextField(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var lastNameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = L10n.Profile.Edit.lastName
        textField.font = CherryFonts.textMedium
        textField.delegate = self
        textField.tag = 1
        textField.addTarget(self, action: #selector(changeTextField(_:)), for: .editingChanged)
        return textField
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.Edit.commentToName
        label.textColor = .cherryGrayBlue
        label.textAlignment = .left
        label.font = CherryFonts.textSmall
        return label
    }()

    private lazy var nameStackView: UIStackView = {
        let names = Const.verticalStackView( [firstNameTextField, lastNameTextField],
                                             spacing: .medium)
        return Const.verticalStackView( [names, commentLabel],
                                        spacing: .small)
    }()

    private lazy var phoneTextField: TextField = {
        let textField = TextField()
        textField.placeholder = L10n.Profile.Edit.phone
        textField.font = CherryFonts.textMedium
        textField.keyboardType = .phonePad
        textField.delegate = self
        textField.tag = 2
        textField.addTarget(self, action: #selector(changeTextField(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var emailButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.title = L10n.Profile.Edit.email
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = CherryFonts.headerMedium
            return outgoing
        })
        config.baseBackgroundColor = .cherryLightBlue
        config.baseForegroundColor = .cherryBlack
        config.titlePadding = 12
        button.configuration = config
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var contactStackView: UIStackView = {
        Const.verticalStackView([ phoneTextField, emailButton ],
                                spacing: .medium)
    }()

    private lazy var birthdateTextField: TextField = {
        let textField = TextField()
        textField.placeholder = L10n.Profile.Edit.birthdate
        textField.font = CherryFonts.textMedium
        textField.datePicker(target: self,
                             doneAction: #selector(datePickerDoneAction),
                             cancelAction: #selector(datePickerCancelAction),
                             deleteAction: #selector(datePickerDeleteAction),
                             datePickerMode: .date)
        textField.tag = 4
        return textField
    }()

    private lazy var genderButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.bordered()
        config.title = L10n.Profile.Edit.gender
        config.subtitle = viewModel.profile.value.gender.label
        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = CherryFonts.headerSmall
            return outgoing
        })
        config.baseBackgroundColor = .cherryLightBlue
        config.baseForegroundColor = .cherryBlack
        config.titlePadding = 2
        button.configuration = config
        button.contentHorizontalAlignment = .left
        button.menu = UIMenu(children: genderUIAction(GenderModel.allCases))
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private lazy var dataContactStackView: UIStackView = {
        Const.verticalStackView([ birthdateTextField, genderButton ],
                                spacing: .medium)
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.Edit.exit, for: .normal)
        button.setTitleColor(.cherryMainAccent, for: .normal)
        button.titleLabel?.font = CherryFonts.headerSmall
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.cherryLightGray.cgColor
        button.layer.cornerRadius = Const.Exit.cornerRadius
        button.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        return button
    }()

    private lazy var generalStackView: UIStackView = {
        Const.verticalStackView([ avatarStackView,
                                  nameStackView,
                                  contactStackView,
                                  dataContactStackView,
                                  exitButton],
                                spacing: .large)
    }()

    // MARK: - Lifecycle
    init(viewModel: EditProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        updateContentSize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationKeyboard()
        viewModel.viewWillAppear()
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisapear()
        bindingOff()
    }

    // MARK: - Private Methods
    @objc
    private func didTapCancelButton() {
        self.coordinator?.exit(hideNavBar: true)
    }

    @objc
    private func didTapDoneButton() {
        viewModel.changeProfile()
        self.coordinator?.exit(hideNavBar: true)
    }
    @objc func tapToScroll() {
        view.endEditing(true)
    }

    @objc
    private func changeAvatarDidTap(_ sender: UITapGestureRecognizer) {
        present(ChangeAvatarViewController(), animated: true)
    }

    @objc
    private func changeTextField(_ textField: UITextField) {
        viewModel.changeTextField(textField.text, tag: textField.tag)
    }

    private func genderUIAction(_ genders: [GenderModel]) -> [UIAction] {
        var actions = [UIAction]()
        genders.forEach { gender in
            let action = UIAction(title: gender.label) { [ weak self ] _ in
                self?.setGenderAction(gender)
            }
            actions.append(action)
        }
        return actions
    }

    private func setGenderAction(_ gender: GenderModel) {
         viewModel.changeGender(gender)
    }

    @objc
    private func datePickerCancelAction() {
        self.birthdateTextField.resignFirstResponder()
    }

    @objc
    private func datePickerDeleteAction() {
        viewModel.changeTextField("", tag: birthdateTextField.tag)
        self.birthdateTextField.resignFirstResponder()
    }

    @objc
    private func datePickerDoneAction() {
        if let datePickerView = self.birthdateTextField.inputView as? UIDatePicker {
            let text = datePickerView.date.customFormatted()
            viewModel.changeTextField(text, tag: birthdateTextField.tag)
            self.birthdateTextField.resignFirstResponder()
        }
    }

    @objc
    private func exitAction() {
        AlertPresenter.showAlert(title: L10n.Profile.Main.exitAlert,
                                 message: nil,
                                 textButton: L10n.Profile.Main.exit) {
            self.coordinator?.navigateToExitAccountScreen()
        }
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }

    private func notificationKeyboard() {
        NotificationCenter.default.addObserver(self,selector:#selector(self.keyboardWillShow),
                                               name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide),
                                               name:UIResponder.keyboardDidHideNotification, object: nil)
    }

    private func bindingOn() {
        viewModel.profile
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] updateModel in
                self?.updateProfileModel(updateModel)
            }.store(in: &avatarUpdated)
    }

    private func bindingOff() {
        avatarUpdated.removeAll()
    }

    private func updateProfileModel(_ updateModel: ProfileUIModel) {
        if let avatarURLString = updateModel.avatar,
           let avatarURL = URL(string: avatarURLString) {
            avatarImage.kf.setImage(with: avatarURL, placeholder: UIImage.avatar)
        } else {
            avatarImage.image = UIImage.avatar
        }
        firstNameTextField.text = updateModel.firstName
        lastNameTextField.text = updateModel.lastName
        phoneTextField.text = updateModel.phone
        birthdateTextField.text = updateModel.birthdate
        emailButton.setTitle(updateModel.email, for: .normal)
        genderButton.configuration?.subtitle = updateModel.gender.label
    }

    // MARK: - Private Layout Setting
    private func updateContentSize() {
        let heightElements = Const.insetV + generalStackView.frame.height + Const.insetV
        let heightOtherElement = view.frame.height - exitButton.frame.height
        let heightContentSize = heightElements > heightOtherElement ? heightElements : heightOtherElement
        contenSize = CGSize(width: view.frame.width, height: heightContentSize)
        scrollView.contentSize = contenSize
        contentView.frame.size = contenSize
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
    }

    private func setupConstraints() {

        [canselButton, doneButton, scrollView].forEach { view.addSubview($0)}

        scrollView.addSubview(contentView)
        contentView.addSubview(generalStackView)

        avatarImage.snp.makeConstraints {
            $0.height.width.equalTo(Const.AvatarStack.avatarWidthHeight)
        }

        let subViews = [ firstNameTextField,
                         lastNameTextField,
                         phoneTextField,
                         emailButton,
                         birthdateTextField,
                         genderButton]

        subViews.forEach { subView in
            subView.snp.makeConstraints {
            $0.height.equalTo(Const.TextField.height)
        } }

        exitButton.snp.makeConstraints {
            $0.height.equalTo(Const.Exit.height)
        }

        canselButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
                .inset(Const.insetH)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        doneButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
                .inset(Const.insetH)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(canselButton.snp.bottom)
            $0.bottom.trailing.leading.equalToSuperview()
        }

        generalStackView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
                .inset(Const.insetH)
            $0.trailing.equalTo(contentView.snp.trailing)
                .inset(Const.insetH)
            $0.top.equalTo(contentView.snp.top)
                .inset(Const.insetV)
        }

        view.layoutIfNeeded()

    }

    private enum Const {
        static let insetH: CGFloat = 16
        static let insetV: CGFloat = 24

        enum AvatarStack {
            static let cornerRadius: CGFloat = 81
            static let avatarWidthHeight: CGFloat = 164
        }
        enum TextField {
            static let height: CGFloat = 44
        }
        enum Exit {
            static let height: CGFloat = 51
            static let cornerRadius: CGFloat = 10
        }
        enum StackSpacing {
            case large
            case medium
            case small

            var spacing: CGFloat {
                switch self {
                case .large:    24
                case .medium:   8
                case .small:    4
                }
            }
        }

        static func verticalStackView(_ subViews: [UIView],
                                      spacing: StackSpacing,
                                      fillOn: Bool = true
        ) -> UIStackView {
            let stackView = UIStackView(arrangedSubviews: subViews)
            stackView.axis = .vertical
            if fillOn { stackView.alignment = .fill } else { stackView.alignment = .center }
            stackView.distribution = .equalSpacing
            stackView.spacing = spacing.spacing
            return stackView
        }
    }

}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
