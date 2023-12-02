import UIKit

class SearchEnabledViewController: UIViewController {
    private(set) var searchBar = UISearchBar()

    override func viewDidLoad() {
        setupUI()
        setupSearchBar()
    }

    private func setupSearchBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        searchBar.searchTextField.backgroundColor = .cherryWhite
        let placeholderAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall,
                          NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue]
        let textAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall,
                          NSAttributedString.Key.foregroundColor: UIColor.cherryBlack]

        searchBar.searchTextField.defaultTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        searchBar.searchTextField.typingAttributes = textAttributes as [NSAttributedString.Key: Any]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("searchPlaceholder",
                                                                                                       tableName: "MainFlow",
                                                                                                       comment: ""),
                                                                             attributes: placeholderAttributes as [NSAttributedString.Key: Any])
        searchBar.setImage(.searchIcon, for: .search, state: .normal)
        searchBar.setImage(.icClose, for: .clear, state: .normal)
        searchBar.barStyle = .black
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .cherryMainAccent
        searchBar.layer.cornerRadius = CornerRadius.regular.cgFloat()
        searchBar.layer.masksToBounds = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .cherryLightBlue
    }
}

extension SearchEnabledViewController: UISearchBarDelegate {

}
