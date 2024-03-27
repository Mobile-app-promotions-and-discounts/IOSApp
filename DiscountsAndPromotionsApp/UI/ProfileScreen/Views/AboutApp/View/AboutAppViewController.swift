import UIKit

class AboutAppViewController: UIViewController {

    // MARK: - Public properties
    weak var coordinator: ProfileScreenCoordinator?

    // MARK: - Private properties
    private var viewModel: AboutAppViewModelProtocol

    private lazy var backButton = UIBarButtonItem(
        image: UIImage(named: "ic_back")?.withTintColor(.cherryBlack).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AboutAppTableViewCell.self,
                           forCellReuseIdentifier: AboutAppTableViewCell.identifier)
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Lifecicle
    init(viewModel: AboutAppViewModelProtocol) {
        self.viewModel = viewModel
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

    // MARK: - Private methods
    @objc
    private func didTapBackButton() {
        coordinator?.navigateBack()
    }

    private func navigateToWebView(to webView: WebViewURL) {
        coordinator?.navigateToWebView(to: webView)
    }

    // MARK: - Private Layout Setting
    private func setupView() {
        view.backgroundColor = .cherryWhite
        setupNavBar()
    }

    private func setupNavBar() {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = backButton
        self.title = L10n.Profile.Main.Property.aboutApp
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
            static let cellHeight: CGFloat = 44
            static let topInset: CGFloat = 4
            static let itsetH: CGFloat = 16
        }
    }

}

// MARK: - UITableViewDataSource
extension AboutAppViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getUrlsCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AboutAppTableViewCell.identifier,
            for: indexPath) as? AboutAppTableViewCell
        else {
            return UITableViewCell()
        }
        let labelName = viewModel.getWebView(row: indexPath.section).name
        cell.configure(name: labelName)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension AboutAppViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is AboutAppTableViewCell else { return }
        let webView = viewModel.getWebView(row: indexPath.section)
        navigateToWebView(to: webView)
    }

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

}
