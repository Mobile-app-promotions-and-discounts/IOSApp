import UIKit
import SnapKit
import Combine

final class EditProfileView: UIView {
    // MARK: - Private properties
    private var viewController: EditProfileViewController

    private var userId: String?

    private let noImage = UIImage.avatar

    // MARK: - Layout elements
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: noImage)
        avatarImage.layer.cornerRadius = 81
        avatarImage.layer.masksToBounds = true
        return avatarImage
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

    private lazy var firstNameTextField: TextField = {
        let firstNameTextField = TextField()
        firstNameTextField.placeholder = L10n.Profile.Edit.firstName
        return firstNameTextField
    }()

    private lazy var lastNameTextField: TextField = {
        let lastNameTextField = TextField()
        lastNameTextField.placeholder = L10n.Profile.Edit.lastName
        return lastNameTextField
    }()

    private lazy var phoneTextField: TextField = {
        let phoneTextField = TextField()
        phoneTextField.placeholder = L10n.Profile.Edit.phone
        phoneTextField.delegate = self
        return phoneTextField
    }()

    private lazy var emailTextField: TextField = {
        let emailTextField = TextField()
        emailTextField.placeholder = L10n.Profile.Edit.email
        emailTextField.isUserInteractionEnabled = false
        return emailTextField
    }()

    private lazy var birthdateTextField: TextField = {
        let birthdateTextField = TextField()
        birthdateTextField.placeholder = L10n.Profile.Edit.birthdate
        birthdateTextField.datePicker(target: self,
                                      doneAction: #selector(datePickerDoneAction),
                                      cancelAction: #selector(datePickerCancelAction),
                                      deleteAction: #selector(datePickerDeleteAction),
                                      datePickerMode: .date)
        return birthdateTextField
    }()

    private lazy var genderTextField: TextField = {
        let genderTextField = TextField()
        genderTextField.placeholder = L10n.Profile.Edit.gender
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(chooseGenderDidTap(_:)))
        genderTextField.isUserInteractionEnabled = true
        genderTextField.addGestureRecognizer(tapAction)
        return genderTextField
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewController: EditProfileViewController, profile: ProfileModel) {
        self.viewController = viewController
        super.init(frame: .zero)

        self.backgroundColor = .cherryWhite

        addAvatar()
        addNameFields()
        addPhoneEmail()
        addBirthdateGender()

        prefillFields(profile: profile)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func collectFieldsToProfile() -> ProfileModel {
        let profile = ProfileModel(
            id: userId,
            avatar: avatarImage == noImage ? nil : avatarImage.image?.pngData(),
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            phone: phoneTextField.text,
            email: emailTextField.text ?? "",
            birthdate: birthdateTextField.text,
            gender: genderTextField.text == "🙎🏼‍♂️")

        return profile
    }

    func setAvatarImage(image: UIImage?) {
        avatarImage.image = image ?? noImage
    }

    // MARK: - Private methods
    private func prefillFields(profile: ProfileModel) {
        if let id = profile.id { userId = id }
        if let avatar = profile.avatar { avatarImage.image = UIImage(data: avatar) }
        if let firstName = profile.firstName { firstNameTextField.text = firstName }
        if let lastName = profile.lastName { lastNameTextField.text = lastName }
        if let phone = profile.phone { phoneTextField.text = phone }
        emailTextField.text = profile.email
        if let birthdate = profile.birthdate { birthdateTextField.text = birthdate }
        if let gender = profile.gender {
            genderTextField.text = gender ? "🙎🏼‍♂️" : "🙎🏼‍♀️"

        }
    }

    @objc
    private func changeAvatarDidTap(_ sender: UITapGestureRecognizer) {
        viewController.changeAvatarDidTap()
    }

    @objc
    private func datePickerCancelAction() {
        self.birthdateTextField.resignFirstResponder()
    }

    @objc
    private func datePickerDeleteAction() {
        self.birthdateTextField.text = ""
        self.birthdateTextField.resignFirstResponder()
    }

    @objc
    private func datePickerDoneAction() {
        if let datePickerView = self.birthdateTextField.inputView as? UIDatePicker {
            self.birthdateTextField.text = datePickerView.date.customFormatted()
            self.birthdateTextField.resignFirstResponder()
        }
    }

    @objc
    private func chooseGenderDidTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: "🙎🏼‍♂️", style: UIAlertAction.Style.default, handler: { _ in
            self.genderTextField.text = "🙎🏼‍♂️"
        }))
        alert.addAction(UIAlertAction(title: "🙎🏼‍♀️", style: UIAlertAction.Style.default, handler: {_ in
            self.genderTextField.text = "🙎🏼‍♀️"
        }))
        if self.genderTextField.text != "" {
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("Delete", tableName: "ProfileFlow", comment: ""),
                style: UIAlertAction.Style.destructive,
                handler: {_ in
                self.genderTextField.text = ""
            }))
        }
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", tableName: "ProfileFlow", comment: ""),
            style: UIAlertAction.Style.default,
            handler: {_ in
                alert.dismiss(animated: true)
        }))

        self.viewController.present(alert, animated: true, completion: nil)
    }

    // MARK: - Layout methods
    private func addAvatar() {
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(162)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(24)
            make.centerX.equalTo(self)
        }
        self.addSubview(changeAvatarLabel)
        changeAvatarLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(4)
            make.centerX.equalTo(self)
        }
    }

    private func addNameFields() {
        self.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalTo(changeAvatarLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self).inset(16)
        }
        self.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { make in
            make.size.leading.trailing.equalTo(firstNameTextField)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(4)

        }
    }

    private func addPhoneEmail() {
        self.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self).inset(16)
        }
        self.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.size.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
        }
    }

    private func addBirthdateGender() {
        self.addSubview(birthdateTextField)
        birthdateTextField.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self).inset(16)
        }
        self.addSubview(genderTextField)
        genderTextField.snp.makeConstraints { make in
            make.size.leading.trailing.equalTo(birthdateTextField)
            make.top.equalTo(birthdateTextField.snp.bottom).offset(4)
        }
    }
}

extension EditProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let unformattedNumber = textField.text else { return }
        phoneTextField.text = unformattedNumber.formatPhoneNumber()
    }
}
