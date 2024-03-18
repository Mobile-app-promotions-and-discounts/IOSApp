import Combine
import UIKit

final class MyReviewViewController: UIViewController {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var viewModel: MyReviewViewModelProtocol
    private var canselable = Set<AnyCancellable>()

    private lazy var backButton = UIBarButtonItem(
        image: UIImage(named: "ic_back")?.withTintColor(.cherryBlack).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyReviewTableViewCell.self,
                           forCellReuseIdentifier: MyReviewTableViewCell.identifier)
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Lifecicle
    init(viewModel: MyReviewViewModelProtocol) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }

    // MARK: - Private methods
    @objc
    private func didTapBackButton() {
        coordinator?.navigateBack()
    }

    private func bindingOn() {
        viewModel.myReviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &canselable)

        viewModel.title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.title = name
            }.store(in: &canselable)
    }

    private func bindingOff() {
        canselable.removeAll()
    }

    // MARK: - Private Layout Setting
    private func setupView() {
        view.backgroundColor = .cherryWhite
        setupNavBar()
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backButton
        self.title = L10n.Profile.Main.Property.myReview
        if let navigationBar = navigationController?.navigationBar {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.cherryBlack,
                NSAttributedString.Key.font: CherryFonts.headerLarge as Any
            ]
            navigationBar.titleTextAttributes = attributes
        }
    }

    private func setupConstraints() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .inset(Const.TableView.topInset)
            $0.trailing.leading.equalToSuperview()
                .inset(Const.TableView.itsetH)
            $0.bottom.equalToSuperview()
        }
    }

    private enum Const {
        enum TableView {
            static let separatorHeight: CGFloat = 8
            static let cellHeight: CGFloat = 115
            static let topInset: CGFloat = 26
            static let itsetH: CGFloat = 16
        }
    }

}

// MARK: - UITableViewDataSource
extension MyReviewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getMyReviewsCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyReviewTableViewCell.identifier,
            for: indexPath) as? MyReviewTableViewCell
        else {
            return UITableViewCell()
        }
        let myReviewModel = viewModel.getMyReviewModel(index: indexPath.section)
        cell.configure(myReviewModel: myReviewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyReviewViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Const.TableView.separatorHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.TableView.cellHeight
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete // или .insert для редактирования
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Ваш код для удаления ячейки
        } else if editingStyle == .insert {
            // Ваш код для редактирования ячейки
        }
    }
}
