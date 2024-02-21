import Combine
import UIKit

final class SelectionCityViewController: SearchEnabledViewController {

    weak var coordinator: AuthCoordinator?
    private let viewModel: SelectionCityViewModelProtocol
    private var cancellables: Set<AnyCancellable>

    private lazy var citiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CityTableViewCell.self,
                           forCellReuseIdentifier: CityTableViewCell.cellIdentifier)
        tableView.allowsMultipleSelection = false
        tableView.separatorInset.left = 0
        tableView.separatorInset.right = 0
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .emptyCherry
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.font = CherryFonts.headerLarge
        label.textColor = .cherryBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var activityIdicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .cherryMainAccent
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    init(viewModel: SelectionCityViewModel) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        bindingOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
        bindingOff()
    }

    private func bindingOn() {

        viewModel.isChangeCities
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] isChange in
                self?.changeTableView(isChange)
            }.store(in: &cancellables)

        viewModel.tableIsEmpty
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] isEmpty in
                self?.tableViewIsEmpty(isEmpty)
            }.store(in: &cancellables)

        viewModel.networkIsWorking
            .receive(on: RunLoop.main)
            .sink { [ weak self ] isWorking in
                self?.isShowActivityIndicator(isWorking)
            }.store(in: &cancellables)
    }

    private func bindingOff() {
        cancellables.removeAll()
    }

    private func tableViewIsEmpty(_ isEmpty: Bool) {
        citiesTableView.isHidden = isEmpty
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
    }

    private func isShowActivityIndicator(_ isShow: Bool) {
        if isShow {
            activityIdicator.startAnimating()
        } else {
            activityIdicator.stopAnimating()
        }
    }

    private func changeTableView(_ isChange: Bool) {
        if isChange { citiesTableView.reloadData() }
    }

    @objc private func backAction() {
        coordinator?.dismissVC(self)
    }

    private func setupView() {
        view.backgroundColor = .cherryWhite
        showBackButton()
        setBackAction {
            self.backAction()
        }
        searchBar.searchTextField.delegate = self
        searchBar.delegate = self
    }

    private func setupConstraints() {

        [emptyImageView,
        emptyLabel,
        citiesTableView,
        activityIdicator].forEach { view.addSubview($0) }

        emptyImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .offset(Const.EmptyView.topOffset)
            $0.centerX.equalToSuperview()
                .offset(Const.EmptyView.centerOffset)
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom)
                .offset(Const.EmptyLabel.topOffset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.EmptyLabel.horizontalInset)
        }

        activityIdicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }

    }

    private enum Const {
        enum EmptyView {
            static let topOffset: CGFloat = 77
            static let centerOffset: CGFloat = 14
        }
        enum EmptyLabel {
            static let horizontalInset: CGFloat = 44
            static let topOffset: CGFloat = 20
        }
    }

}

// MARK: - UITextFieldDataSource
extension SelectionCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = citiesTableView.dequeueReusableCell(
            withIdentifier: CityTableViewCell.cellIdentifier,
            for: indexPath) as? CityTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configureCity(viewModel.visibleCities[indexPath.row])
        cell.tag = indexPath.row
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension SelectionCityViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = citiesTableView.cellForRow(at: indexPath) as? CityTableViewCell else { return }
        viewModel.selectCity(cell.tag)
    }
}

// MARK: - UITextFieldDelegate
extension SelectionCityViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

}

// MARK: - UISearchBarDelegate

extension SelectionCityViewController {

    func searchBar(_: UISearchBar, textDidChange: String) {
        viewModel.findCity(textDidChange)
    }

    func searchBarShouldEndEditing(_: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
