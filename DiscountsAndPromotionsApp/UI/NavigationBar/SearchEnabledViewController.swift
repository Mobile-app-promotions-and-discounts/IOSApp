import UIKit

class SearchEnabledViewController: CherryCustomViewController {
    private(set) var searchBar = UISearchBar()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func setupSearchBar() {
        searchBar.searchTextField.backgroundColor = .cherryLightBlue
        let placeholderAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall,
                                     NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue]
        let textAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall]

        searchBar.searchTextField.defaultTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        searchBar.searchTextField.textColor = .cherryBlack
        searchBar.searchTextField.typingAttributes = textAttributes as [NSAttributedString.Key: Any]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("searchPlaceholder", tableName: "MainFlow", comment: ""),
                                                                             attributes: placeholderAttributes as [NSAttributedString.Key: Any])
        searchBar.setImage(.searchIcon, for: .search, state: .normal)
        searchBar.setImage(.icClose, for: .clear, state: .normal)
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .cherryMainAccent
        searchBar.layer.cornerRadius = CornerRadius.regular.cgFloat()
        searchBar.layer.masksToBounds = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
}

extension SearchEnabledViewController: UISearchBarDelegate {}
