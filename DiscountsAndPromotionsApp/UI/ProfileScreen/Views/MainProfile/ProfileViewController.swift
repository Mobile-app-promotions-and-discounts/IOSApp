import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private var profileView: ProfileView?
    private var viewModel: ProfileViewModelProtocol

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
        self.navigationController?.navigationBar.isHidden = true

    }

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.profileView = ProfileView(frame: .zero, viewModel: self.viewModel, viewController: self)

        self.navigationController?.navigationBar.backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func editDidTap() {
        let editProfileViewController = EditProfileViewController(viewModel: ProfileViewModel())
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    @objc
    func regionDidTap() {
        print("Tap!")
    }

    // MARK: - Private methods

}
