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

        self.view = EditProfileView(frame: .zero, viewController: self, viewModel: viewModel)

    }

    override func viewDidAppear(_ animated: Bool) {
        setupNavBar()
    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods
    @objc
    private func didTapCancelButton() {
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func didTapDoneButton() {
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }

    private func setupNavBar() {
//        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        self.navigationController?.navigationBar.isHidden = false
    }
}
