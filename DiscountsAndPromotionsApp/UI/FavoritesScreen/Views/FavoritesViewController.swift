import UIKit
import Combine
import SnapKit

final class FavoritesViewController: ProductListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    private func setupNavigation() {
        backButton.removeTarget(self, action: nil, for: .touchUpInside)
    }
}
