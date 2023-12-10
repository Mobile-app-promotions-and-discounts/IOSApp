import UIKit
import MapKit

final class ChooseRegionViewController: UIViewController {
    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults: [String] = []

    // MARK: - Layout elements
    private lazy var backButton = UIBarButtonItem(
        image: UIImage(named: "ic_back")?.withTintColor(.cherryBlack).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    private lazy var titleLabel = UIBarButtonItem(
        title: NSLocalizedString("Region", tableName: "ProfileFlow", comment: ""),
        style: .plain,
        target: self,
        action: nil
    )

    private lazy var resultsTable: UITableView = {
        let resultsTable = UITableView()
        resultsTable.backgroundColor = .cherryWhite
        resultsTable.layer.cornerRadius = CornerRadius.regular.cgFloat()
        resultsTable.layer.masksToBounds = true
        resultsTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        resultsTable.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        resultsTable.allowsMultipleSelection = false
        resultsTable.dataSource = self
        resultsTable.delegate = self
        return resultsTable
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .cherryWhite
        setupNavBar()
        addTable()

        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.query])
    }

    // MARK: - Private Methods
    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItems = [backButton, titleLabel]

        let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.cherryBlack,
            NSAttributedString.Key.font: CherryFonts.headerLarge as Any]
        titleLabel.setTitleTextAttributes(titleAttributes, for: .normal)

        let searchController = UISearchController()
        searchController.searchBar.placeholder = NSLocalizedString("Search", tableName: "ProfileFlow", comment: "")
        searchController.searchBar.barTintColor = .cherryLightBlue
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }

    @objc
    private func didTapBackButton() {
        self.coordinator?.exit(hideNavBar: false)
    }

    // MARK: - Layout methods
    private func addTable() {
        self.view.addSubview(resultsTable)
        resultsTable.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view).inset(16)
        }
    }
}

extension ChooseRegionViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchResults = []
            if searchText == "" { resultsTable.reloadData() }
            searchCompleter.queryFragment = searchText

        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchResults = []
            resultsTable.reloadData()
        }
}

extension ChooseRegionViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        var completerResults: [String] = []
        completer.results.forEach { result in
            if result.subtitle.contains("Россия") || result.subtitle.contains("Russia") {
                completerResults.append(result.title)
            }
        }
        searchResults = Array(Set(completerResults))
        searchResults.sort()
        resultsTable.reloadData()
    }

    private func completer(completer: MKLocalSearchCompleter, didFailWithError error: NSError) {
        ErrorHandler.handle(error: .locationError)
    }
}

extension ChooseRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath as IndexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.backgroundColor = .cherryLightBlue
        cell.textLabel?.textColor = .cherryBlack
        cell.selectionStyle = .none
        return cell
    }
}

extension ChooseRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(
            name: Notification.Name("manualLocation"),
            object: searchResults[indexPath.row]
        )

        coordinator?.exit(hideNavBar: false)
    }
}
