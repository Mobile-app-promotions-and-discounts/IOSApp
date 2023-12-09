import Combine
import UIKit

final class SearchResultsViewController: CategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
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
//
// final class SearchResultsViewController: ScannerEnabledViewController {
//    weak var coordinator: MainScreenCoordinator?
//    // для теста на существующих данных
//    private let viewModel: CategoryViewModelProtocol
//    private let layoutProvider: CollectionLayoutProvider
//
//    private var subscriptions = Set<AnyCancellable>()
//
//    private lazy var nothingFoundLabel: UILabel = {
//        let label = UILabel()
//        label.text = NSLocalizedString("nothingFound", tableName: "MainFlow", comment: "")
//        label.font = CherryFonts.headerExtraLarge
//        label.numberOfLines = 0
//        label.textColor = .cherryGrayBlue
//        label.textAlignment = .center
//        return label
//    }()
//    private lazy var resultsCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .cherryLightBlue
//        return collectionView
//    }()
//
//    init(viewModel: CategoryViewModelProtocol,
//         layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
//        self.layoutProvider = layoutProvider
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigation()
//        setupUI()
//        setupBindings()
//    }
//
//    private func setupUI() {
//        view.addSubview(nothingFoundLabel)
//        nothingFoundLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().offset(24)
//            make.trailing.equalToSuperview().offset(-24)
//        }
//
//       // Изменил метод для создания layout
////        layoutProvider.createCategoryScreenLayout(for: resultsCollectionView, in: view)
//        view.addSubview(resultsCollectionView)
//        resultsCollectionView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(12)
//            make.top.bottom.equalToSuperview()
//        }
//    }
//
//    private func setupBindings() {
//        viewModel.productsUpdate
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                self.resultsCollectionView.reloadData()
//            }
//            .store(in: &subscriptions)
//    }
//
//    private func setupNavigation() {
//        backButton.removeTarget(self, action: nil, for: .touchUpInside)
//        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//    }
//
//    @objc
//    private func backAction() {
//        coordinator?.navigateToMainScreen()
//    }
// }
//
// MARK: - Search field delegate
// extension SearchResultsViewController {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        coordinator?.navigateToSearchScreen()
//    }
// }
//
// MARK: - Collection view
// extension SearchResultsViewController: UICollectionViewDelegate {}
//
// extension SearchResultsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.numberOfItems()
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier,
//                                                            for: indexPath) as? ProductCell else {
//            return UICollectionViewCell()
//        }
//
//        cell.cancellable = cell.likeButtonTappedPublisher
//            .sink { [weak self] productID in
//                guard let self = self else { return }
//                self.viewModel.likeButtonTapped(for: productID)
//            }
//
//        let product = viewModel.getProduct(for: indexPath.row)
//        cell.configure(with: product)
//
//        return cell
//    }
// }
