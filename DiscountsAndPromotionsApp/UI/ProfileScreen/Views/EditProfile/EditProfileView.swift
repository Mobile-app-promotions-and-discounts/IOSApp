import UIKit

final class EditProfileView: UIView {
    // MARK: - Properties
    private var viewController: EditProfileViewController

    // MARK: - Layout elements
    private lazy var avatarImage: UIImageView = {
        let placeholder = UIImage(systemName: "person.circle")?.withTintColor(.buttonBG, renderingMode: .alwaysOriginal)
        let avatarImage = UIImageView(image: placeholder)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.layer.cornerRadius = 65
        avatarImage.layer.masksToBounds = true
        return avatarImage
    }()

    private lazy var changeAvatarLabel: UILabel = {
        let changeAvatarLabel = UILabel()
        changeAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
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
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
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
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.placeholder = NSLocalizedString("LastName", tableName: "ProfileFlow", comment: "")
        lastNameTextField.backgroundColor = .buttonBG
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.layer.masksToBounds = true
        lastNameTextField.font = .systemFont(ofSize: 14)
        lastNameTextField.textColor = .black
        lastNameTextField.insets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return lastNameTextField
    }()

    //    private lazy var commentToNameFields: UILabel = {
    //        let commentToNameFields = UILabel()
    //        commentToNameFields.translatesAutoresizingMaskIntoConstraints = false
    //        commentToNameFields.font = .systemFont(ofSize: 15)
    //        commentToNameFields.textColor = .black.withAlphaComponent(0.54)
    //        commentToNameFields.text = NSLocalizedString("CommentToName", tableName: "ProfileFlow", comment: "")
    //        return commentToNameFields
    //    }()

    private lazy var phoneTextField: TextField = {
        let phoneTextField = TextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
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
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
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
        birthdateTextField.translatesAutoresizingMaskIntoConstraints = false
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
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
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

        self.backgroundColor = .mainBG

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
            avatar: nil,
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            phone: phoneTextField.text,
            email: emailTextField.text ?? "",
            birthdate: birthdateTextField.text,
            gender: genderTextField.text == "🙎🏼‍♂️")

        return profile
    }

    func setAvatarImage(image: UIImage?) {
        avatarImage.image = image ?? UIImage(
            systemName: "person.circle")?.withTintColor(.buttonBG, renderingMode: .alwaysOriginal
            )
    }

    // MARK: - Private methods
    private func prefillFields(profile: ProfileModel) {

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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.birthdateTextField.text = dateString
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
        self.addSubview(changeAvatarLabel)
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 130),
            avatarImage.widthAnchor.constraint(equalToConstant: 130),
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            changeAvatarLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 4),
            changeAvatarLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func addNameFields() {
        self.addSubview(firstNameTextField)
        self.addSubview(lastNameTextField)
        //        self.addSubview(commentToNameFields)
        NSLayoutConstraint.activate([
            firstNameTextField.heightAnchor.constraint(equalToConstant: 52),
            firstNameTextField.topAnchor.constraint(equalTo: changeAvatarLabel.bottomAnchor, constant: 20),
            firstNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 52),
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 4),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor)
            // commentToNameFields.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 4),
            // commentToNameFields.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            // commentToNameFields.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor)
        ])
    }

    private func addPhoneEmail() {
        self.addSubview(phoneTextField)
        self.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            phoneTextField.heightAnchor.constraint(equalToConstant: 52),
            phoneTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 4),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func addBirthdateGender() {
        self.addSubview(birthdateTextField)
        self.addSubview(genderTextField)
        NSLayoutConstraint.activate([
            birthdateTextField.heightAnchor.constraint(equalToConstant: 52),
            birthdateTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            birthdateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            birthdateTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            genderTextField.heightAnchor.constraint(equalToConstant: 52),
            genderTextField.topAnchor.constraint(equalTo: birthdateTextField.bottomAnchor, constant: 4),
            genderTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genderTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

}

extension TextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)

            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = .inline
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
