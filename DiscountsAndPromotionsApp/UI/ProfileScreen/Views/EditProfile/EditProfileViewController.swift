import UIKit

final class EditProfileViewController: UIViewController {

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
        print("Change")
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
        print(view?.collectFieldsToProfile())

        self.navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
}
