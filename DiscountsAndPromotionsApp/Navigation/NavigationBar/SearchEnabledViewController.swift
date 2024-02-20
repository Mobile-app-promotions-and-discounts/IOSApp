import UIKit

class SearchEnabledViewController: UIViewController {
    private(set) var searchBar = UISearchBar()
    private(set) var statusBarBackground = UIView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(statusBarBackground)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    private func setupSearchBar() {
        navigationItem.backButtonDisplayMode = .minimal

        searchBar.searchTextField.backgroundColor = .cherryWhite
        let placeholderAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall,
                                     NSAttributedString.Key.foregroundColor: UIColor.cherryGrayBlue]
        let textAttributes = [NSAttributedString.Key.font: CherryFonts.inputSmall]

        searchBar.searchTextField.defaultTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        searchBar.searchTextField.textColor = .cherryBlack
        searchBar.searchTextField.typingAttributes = textAttributes as [NSAttributedString.Key: Any]
        let text = NSLocalizedString("searchPlaceholder", tableName: "MainFlow", comment: "")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                                                                        string: text,
                                                                        attributes: placeholderAttributes as
                                                                        [NSAttributedString.Key: Any])
        searchBar.setImage(.searchIcon, for: .search, state: .normal)
        searchBar.setImage(.icClose, for: .clear, state: .normal)
        searchBar.backgroundColor = .clear
        searchBar.tintColor = .cherryMainAccent
        searchBar.layer.cornerRadius = CornerRadius.regular.cgFloat()
        searchBar.layer.masksToBounds = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    private func setupUI() {
        statusBarBackground.backgroundColor = .cherryMainAccent
        view.addSubview(statusBarBackground)
        statusBarBackground.frame = UIApplication.shared.statusBarFrame

        view.backgroundColor = .cherryLightBlue
    }
}

extension SearchEnabledViewController: UISearchBarDelegate {

}
