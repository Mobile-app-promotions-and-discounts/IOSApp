import UIKit

class SearchEnabledViewController: UIViewController {
    private(set) var searchBar = UISearchBar()

    override func viewDidLoad() {
        setupUI()
        setupSearchBar()
    }

    private func setupSearchBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", tableName: "MainFlow", comment: "")
        searchBar.searchTextField.backgroundColor = .cherryWhite
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .cherryLightBlue
    }
}

extension SearchEnabledViewController: UISearchBarDelegate {

}
