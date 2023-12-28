import Combine
import UIKit

final class SearchResultsViewController: CategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    private func setupNavigation() {
        backButton.removeTarget(self, action: nil, for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    @objc
    private func backAction() {
        coordinator?.navigateToMainScreen()
    }
}
