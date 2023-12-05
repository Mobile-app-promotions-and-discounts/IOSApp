import UIKit
import SnapKit

final class EditProfileView: UIView {
    // MARK: - Properties
    private var viewController: EditProfileViewController

    private let noImage = UIImage(systemName: "person.circle")?.withTintColor(.buttonBG, renderingMode: .alwaysOriginal)

    // MARK: - Layout elements
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: noImage)
        avatarImage.layer.cornerRadius = 65
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var changeAvatarLabel: UILabel = {
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.text = NSLocalizedString("ChoosePhoto", tableName: "ProfileFlow", comment: "")
        changeAvatarLabel.font = .systemFont(ofSize: 20)
        changeAvatarLabel.textColor = .systemBlue
        changeAvatarLabel.textAlignment = .center
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(changeAvatarDidTap(_:)))
        changeAvatarLabel.isUserInteractionEnabled = true
        changeAvatarLabel.addGestureRecognizer(tapAction)
        return changeAvatarLabel
    }()

    private lazy var firstNameTextField: TextField = {
        let firstNameTextField = TextField()
        firstNameTextField.placeholder = NSLocalizedString("FirstName", tableName: "ProfileFlow", comment: "")
        firstNameTextField.backgroundColor = .buttonBG
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.layer.masksToBounds = true
        firstNameTextField.font = .systemFont(ofSize: 14)
        firstNameTextField.textColor = .black
        firstNameTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return firstNameTextField
    }()

    private lazy var lastNameTextField: TextField = {
        let lastNameTextField = TextField()
        lastNameTextField.placeholder = NSLocalizedString("LastName", tableName: "ProfileFlow", comment: "")
        lastNameTextField.backgroundColor = .buttonBG
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.layer.masksToBounds = true
        lastNameTextField.font = .systemFont(ofSize: 14)
        lastNameTextField.textColor = .black
        lastNameTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return lastNameTextField
    }()

    private lazy var phoneTextField: TextField = {
        let phoneTextField = TextField()
        phoneTextField.placeholder = NSLocalizedString("Phone", tableName: "ProfileFlow", comment: "")
        phoneTextField.backgroundColor = .buttonBG
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.layer.masksToBounds = true
        phoneTextField.font = .systemFont(ofSize: 14)
        phoneTextField.textColor = .black
        phoneTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return phoneTextField
    }()

    private lazy var emailTextField: TextField = {
        let emailTextField = TextField()
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = .buttonBG
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.textColor = .black
        emailTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        emailTextField.isUserInteractionEnabled = false
        return emailTextField
    }()

    private lazy var birthdateTextField: TextField = {
        let birthdateTextField = TextField()
        birthdateTextField.placeholder = NSLocalizedString("Birthdate", tableName: "ProfileFlow", comment: "")
        birthdateTextField.backgroundColor = .buttonBG
        birthdateTextField.layer.cornerRadius = 10
        birthdateTextField.layer.masksToBounds = true
        birthdateTextField.font = .systemFont(ofSize: 14)
        birthdateTextField.textColor = .black
        birthdateTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        birthdateTextField.datePicker(target: self,
                                      doneAction: #selector(datePickerDoneAction),
                                      cancelAction: #selector(datePickerCancelAction),
                                      datePickerMode: .date)
        return birthdateTextField
    }()

    private lazy var genderTextField: TextField = {
        let genderTextField = TextField()
        genderTextField.placeholder = NSLocalizedString("Gender", tableName: "ProfileFlow", comment: "")
        genderTextField.backgroundColor = .buttonBG
        genderTextField.layer.cornerRadius = 10
        genderTextField.layer.masksToBounds = true
        genderTextField.font = .systemFont(ofSize: 14)
        genderTextField.textColor = .black
        genderTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(chooseGenderDidTap(_:)))
        genderTextField.isUserInteractionEnabled = true
        genderTextField.addGestureRecognizer(tapAction)
        return genderTextField
    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewController: EditProfileViewController, profile: ProfileModel) {
        self.viewController = viewController
        super.init(frame: .zero)

        self.backgroundColor = .cherryLightBlue

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
            id: nil,
            avatar: avatarImage.image?.pngData(),
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
    private func datePickerDoneAction() {
        if let datePickerView = self.birthdateTextField.inputView as? UIDatePicker {
            self.birthdateTextField.text = datePickerView.date.customFormatted()
            self.birthdateTextField.resignFirstResponder()
        }
    }

    @objc
    private func chooseGenderDidTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(
            title: NSLocalizedString("Gender", tableName: "ProfileFlow", comment: ""),
            message: nil,
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: "🙎🏼‍♂️", style: UIAlertAction.Style.default, handler: { _ in
            self.genderTextField.text = "🙎🏼‍♂️"
        }))
        alert.addAction(UIAlertAction(title: "🙎🏼‍♀️", style: UIAlertAction.Style.default, handler: {_ in
            self.genderTextField.text = "🙎🏼‍♀️"
        }))

        self.viewController.present(alert, animated: true, completion: nil)
    }

    // MARK: - Layout methods
    private func addAvatar() {
        self.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.height.width.equalTo(130)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(20)
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
