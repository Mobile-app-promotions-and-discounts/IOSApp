import UIKit

final class SearchViewController: SearchEnabledViewController {
    private let allCategories = Array(SearchCategory.allCases)
    private lazy var categoriesTable: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCategoryCell.self, forCellReuseIdentifier: SearchCategoryCell.reuseIdentiffier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .cherryLightBlue
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(categoriesTable)
        categoriesTable.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        categoriesTable.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension SearchViewController: UITableViewDelegate {

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoryCell.reuseIdentiffier, for: indexPath) as? SearchCategoryCell else {
            return UITableViewCell()
        }
        cell.setUpCell(with: allCategories[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

// MARK: - Search field delegate
extension SearchViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
}
