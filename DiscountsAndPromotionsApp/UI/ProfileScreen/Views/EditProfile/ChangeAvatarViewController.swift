import UIKit
import AVFoundation
import Combine

final class ChangeAvatarViewController: UIViewController {

    // MARK: - Private properties
    var avatarUpdated = Set<AnyCancellable>()

    private lazy var cameraButton: CameraButton = {
        let cameraButton = CameraButton()
        cameraButton.setTitle(NSLocalizedString("Camera", tableName: "ProfileFlow", comment: ""), for: .normal)
        cameraButton.addAction(UIAction(handler: { [weak self] _ in
            self?.takePhoto(fromCamera: true)
        }), for: .touchUpInside)
        return cameraButton
    }()

    private lazy var galleryButton: CameraButton = {
        let galleryButton = CameraButton()
        galleryButton.setTitle(NSLocalizedString("Gallery", tableName: "ProfileFlow", comment: ""), for: .normal)
        galleryButton.addAction(UIAction(handler: { [weak self] _ in
            self?.takePhoto(fromCamera: false)
        }), for: .touchUpInside)
        return galleryButton
    }()

    private lazy var deleteButton: CameraButton = {
        let deleteButton = CameraButton()
        deleteButton.setTitle(NSLocalizedString("DeletePhoto", tableName: "ProfileFlow", comment: ""), for: .normal)
        deleteButton.setTitleColor(.cherryMainAccent, for: .normal)
        deleteButton.addAction(UIAction(handler: { [weak self] _ in
            NotificationCenter.default.post(
                name: Notification.Name("updateAvatar"),
                object: nil
            )
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        return deleteButton
    }()

    private lazy var buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 4
        buttonsStack.distribution = .fillEqually
        return buttonsStack
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cherryWhite
        self.view.layer.cornerRadius = 20

        if #available(iOS 16.0, *) {
            self.sheetPresentationController?.detents = [UISheetPresentationController.Detent.custom { _ in 216 }]
        } else {
            self.sheetPresentationController?.detents = [.medium()]
        }

        addButtons()
    }

    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    private func takePhoto(fromCamera: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - Layout Methods
    private func addButtons() {
        self.view.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(view).inset(24)
            make.bottom.equalTo(view).inset(31)
            make.leading.trailing.equalTo(view).inset(16)
        }
        [cameraButton,
         galleryButton,
         deleteButton].forEach {
            buttonsStack.addArrangedSubview($0)
        }
    }
}

extension ChangeAvatarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

        dismiss(animated: true, completion: { [self] in

            NotificationCenter.default.post(
                name: Notification.Name("updateAvatar"),
                object: image
            )

            self.dismiss(animated: true)
        })
    }
}
