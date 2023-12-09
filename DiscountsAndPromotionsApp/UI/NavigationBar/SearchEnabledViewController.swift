import UIKit

class SearchEnabledViewController: UIViewController {
    private(set) var searchBar = UISearchBar()

    lazy var backButton = { [weak self] in
        guard let self else {
            return UIButton()
        }
        let backButton = UIButton(type: .system)
        backButton.setImage(.icBack, for: .normal)
        backButton.addTarget(self,
                             action: #selector(defaultBackAction),
                             for: .touchUpInside)
        backButton.contentMode = .right
        return backButton
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.searchTextField.backgroundColor = .cherryWhite
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

    private func setupUI() {
        view.backgroundColor = .cherryLightBlue

        navigationItem.hidesBackButton = true
        if self != navigationController?.viewControllers[0] {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }

    @objc
    private func defaultBackAction() {
        // не уверен стоит ли в протокол отдельный координатор добавлять и везде прокидывать?
        navigationController?.popViewController(animated: true)
    }
}

extension SearchEnabledViewController: UISearchBarDelegate {

}
