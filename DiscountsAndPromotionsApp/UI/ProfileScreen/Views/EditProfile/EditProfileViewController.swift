import UIKit
import AVFoundation
import Combine

final class EditProfileViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

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
        // В дизайне этой кнопки нет, но это очевидная ошибка, она должна быть
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
        self.coordinator?.exit()
    }

    @objc
    private func didTapDoneButton() {
        let view = self.view as? EditProfileView
        guard let profile = view?.collectFieldsToProfile() else { return }

        NotificationCenter.default.post(
            name: Notification.Name("updateProfile"),
            object: profile
        )

        self.coordinator?.exit()
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
        let navbarAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.cherryBlue,
            NSAttributedString.Key.font: CherryFonts.textLarge as Any]
        navigationItem.leftBarButtonItem = cancelButton
        cancelButton.setTitleTextAttributes(navbarAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(navbarAttributes, for: .selected)
        navigationItem.rightBarButtonItem = doneButton
        doneButton.setTitleTextAttributes(navbarAttributes, for: .normal)
        doneButton.setTitleTextAttributes(navbarAttributes, for: .selected)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: { [weak self] in
            let view = self?.view as? EditProfileView
            view?.setAvatarImage(image: image)
        })
    }
}
