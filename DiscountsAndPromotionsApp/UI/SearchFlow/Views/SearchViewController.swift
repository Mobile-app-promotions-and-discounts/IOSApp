import Combine
import UIKit

 final class SearchViewController: SearchEnabledViewController {
    weak var coordinator: MainScreenCoordinator?
    private var viewModel: SearchViewModel
    private var subscriptions = Set<AnyCancellable>()

    private lazy var categoriesTable: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCategoryCell.self, forCellReuseIdentifier: SearchCategoryCell.reuseIdentiffier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .cherryLightBlue
        tableView.separatorStyle = .none
        return tableView
    }()

    init(coordinator: MainScreenCoordinator? = nil,
         viewModel: SearchViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupBindings()
    }

    private func setupUI() {
        view.addSubview(categoriesTable)
        categoriesTable.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        categoriesTable.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    private func setupBindings() {
        viewModel.categoriesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                categoriesTable.reloadData()
            }
            .store(in: &subscriptions)
    }

     private func setupNavigation() {
         backButton.removeTarget(self, action: nil, for: .touchUpInside)
         backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
     }

     @objc
     private func backAction() {
         coordinator?.navigateToMainScreen()
     }
 }

 extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let category = viewModel.getCategory(for: indexPath.row) {
            self.coordinator?.navigateToCategoryScreen(with: category)
        } else {
            ErrorHandler.handle(error: .customError("Потерялась категория"))
        }
    }
 }

 extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCategoryCell.reuseIdentiffier,
                                                       for: indexPath)
                as? SearchCategoryCell else {
            return UITableViewCell()
        }
        let category = viewModel.getSearchCategory(for: indexPath.row)
        cell.setUpCell(with: category)
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            coordinator?.navigateToSearchResultsScreen(for: text)
        }
    }
 }
