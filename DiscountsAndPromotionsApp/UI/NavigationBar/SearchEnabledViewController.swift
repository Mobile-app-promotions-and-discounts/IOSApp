import UIKit

class SearchEnabledViewController: UIViewController {
    weak var searchCoordinator: SearchFlowCoordinator? = SearchFlowCoordinator.shared
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        startSearch()
    }

    @objc
    private func startSearch() {
        if let navigationController {
            searchCoordinator?.navigationController = navigationController
            searchCoordinator?.start()
        }
    }
}
