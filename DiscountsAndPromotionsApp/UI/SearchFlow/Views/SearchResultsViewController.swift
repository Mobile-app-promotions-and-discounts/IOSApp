import Combine
import UIKit

final class SearchResultsViewController: CategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
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
