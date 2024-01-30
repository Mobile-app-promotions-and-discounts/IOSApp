import UIKit
import Combine
import SnapKit

final class FavoritesViewController: ProductListViewController {
    override init(viewModel: ProductListViewModelProtocol,
                  layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        super.init(viewModel: viewModel, layoutProvider: layoutProvider)
        setEmptyResultsMode(to: .noFavorites)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesViewController {
    override func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        hideScanButton()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            coordinator?.navigateToSearchResultsScreen(for: text)
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        showScanButton()
    }
}
