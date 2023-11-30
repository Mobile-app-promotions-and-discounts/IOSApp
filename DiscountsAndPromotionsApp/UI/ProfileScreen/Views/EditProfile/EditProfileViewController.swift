import UIKit
import AVFoundation

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Private properties
    private let viewModel: ProfileViewModelProtocol

    // MARK: - Layout elements
    private lazy var cancelButton = UIBarButtonItem(
        title: NSLocalizedString("Cancel", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: #selector(didTapCancelButton))

    private lazy var doneButton = UIBarButtonItem(
        title: NSLocalizedString("Done", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: #selector(didTapDoneButton))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        guard let profile = viewModel.profile else { return }
        self.view = EditProfileView(frame: .zero, viewController: self, profile: profile)
    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func changeAvatarDidTap() {
        let alert = UIAlertController(nibName: nil, bundle: nil)
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Camera", tableName: "ProfileFlow", comment: ""),
            style: UIAlertAction.Style.default,
            handler: { [weak self] _ in self?.takePhoto(fromCamera: true) })
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Gallery", tableName: "ProfileFlow", comment: ""),
            style: UIAlertAction.Style.default,
            handler: { [weak self] _ in self?.takePhoto(fromCamera: false) })
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("DeletePhoto", tableName: "ProfileFlow", comment: ""),
            style: UIAlertAction.Style.destructive,
            handler: { _ in
                let view = self.view as? EditProfileView
                view?.setAvatarImage(image: nil)
            })
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", tableName: "ProfileFlow", comment: ""),
            style: UIAlertAction.Style.cancel,
            handler: { _ in self.dismiss(animated: true) })
        )

        self.present(alert, animated: true)
    }

    // MARK: - Private Methods
    @objc
    private func didTapCancelButton() {
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func didTapDoneButton() {
        let view = self.view as? EditProfileView
        guard let profile = view?.collectFieldsToProfile() else { return }
        viewModel.putProfileData(profile: profile)

        self.navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }

    private func validateProfile(profile: ProfileModel) {
        // TODO: add validation
    }

    private func takePhoto(fromCamera: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
            imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
                imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            }
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: {
            let view = self.view as? EditProfileView
            view?.setAvatarImage(image: image)
        })
    }
}

extension EditProfileViewController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "[0-9]"

        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }

}

extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }

    var isPhone: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
}
