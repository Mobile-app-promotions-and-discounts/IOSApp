import UIKit

final class SearchViewController: SearchEnabledViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
}
