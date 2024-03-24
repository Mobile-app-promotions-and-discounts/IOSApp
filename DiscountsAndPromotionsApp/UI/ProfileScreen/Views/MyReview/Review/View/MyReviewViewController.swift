import Combine
import UIKit

final class MyReviewViewController: UIViewController {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var viewModel: MyReviewViewModelProtocol
    private var canselable = Set<AnyCancellable>()

    // MARK: - Private layout properties
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .cherryMainAccent
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchReviews), for: .valueChanged)
        return refreshControl
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
        viewModel.fetchMyReviews()
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

        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isShowActivityIndicator(isLoading)
            }.store(in: &canselable)
    }

    private func bindingOff() {
        canselable.removeAll()
    }

    private func isShowActivityIndicator(_ isLoading: Bool) {
        if isLoading == true {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    @objc
    private func fetchReviews() {
        viewModel.fetchMyReviews()
        refreshControl.endRefreshing()
    }

    private func editReview(_ index: Int) {
        let reviewId = viewModel.getMyReviewModel(index: index).id
        coordinator?.navigateToEditReviewScreen(from: self, id: reviewId)
    }

    // MARK: - Private Layout Setting
    private func setupView() {
        view.backgroundColor = .cherryWhite
        setupNavBar()
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backButton
        self.title = viewModel.title.value
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
        tableView.addSubview(refreshControl)
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                .inset(Const.TableView.topInset)
            $0.trailing.leading.equalToSuperview()
                .inset(Const.TableView.itsetH)
            $0.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private enum Const {
        enum TableView {
            static let separatorHeight: CGFloat = 8
            static let cellHeight: CGFloat = 115
            static let topInset: CGFloat = 0
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
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.TableView.cellHeight
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // edit
        let edit = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in

            self?.editReview(indexPath.section)
            completionHandler(true)
        }
        edit.image = .cellEdit
        edit.backgroundColor = .cherryGray

        // delete
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
            if let id = self?.viewModel.myReviews.value[indexPath.section].id {
                self?.viewModel.deleteReview(index: id)
            }
            completionHandler(true)
        }
        delete.image = .cellDelete
        delete.backgroundColor = .cherryMainAccent

        let swipe = UISwipeActionsConfiguration(actions: [delete,edit])
        return swipe
    }

}

// MARK: - Exitension UIViewControllerTransitioningDelegate
extension MyReviewViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }

}
