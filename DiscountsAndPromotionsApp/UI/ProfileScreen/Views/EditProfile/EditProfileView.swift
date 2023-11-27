import UIKit

final class EditProfileView: UIView {
    // MARK: - Properties
    private var viewModel: ProfileViewModelProtocol
    private var viewController: EditProfileViewController

    // MARK: - Layout elements
//    private lazy var closeButton: UIButton = {
//        let closeButton = UIButton()
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        closeButton.accessibilityIdentifier = "closeButton"
//        closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
//        closeButton.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
//        return closeButton
//    }()

    // MARK: - Lifecycle
    init(frame: CGRect, viewController: EditProfileViewController, viewModel: ProfileViewModelProtocol) {
        self.viewController = viewController
        self.viewModel = viewModel
        super.init(frame: .zero)

        self.backgroundColor = .mainBG
//        addCloseButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    @objc
    private func closeDidTap(_ sender: UITapGestureRecognizer) {
        viewController.navigationController?.popViewController(animated: true)
    }

    // MARK: - Layout methods
//    private func addCloseButton() {
//        self.addSubview(closeButton)
//        NSLayoutConstraint.activate([
//            closeButton.heightAnchor.constraint(equalToConstant: 42),
//            closeButton.widthAnchor.constraint(equalToConstant: 42),
//            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
//            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
//        ])
//    }
}
