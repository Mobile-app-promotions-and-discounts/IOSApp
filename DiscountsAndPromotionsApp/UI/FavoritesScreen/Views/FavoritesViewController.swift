import UIKit
import Combine
import SnapKit

final class FavoritesViewController: ProductListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refresh()
    }

    private func setupNavigation() {
        backButton.removeTarget(self, action: nil, for: .touchUpInside)
    }
}
