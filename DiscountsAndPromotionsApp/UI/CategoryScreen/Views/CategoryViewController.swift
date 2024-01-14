import UIKit
import SnapKit
import Combine

class CategoryViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: CategoryViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    private let emptyResultView: EmptyOnScreenView

    private var cancellables = Set<AnyCancellable>()
    private var visibleCancellables = Set<AnyCancellable>()

    private lazy var progressView: UIActivityIndicatorView = {
        let progressView = UIActivityIndicatorView(style: .large)
        progressView.hidesWhenStopped = true
        return progressView
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = layoutProvider.createGoodsScreensLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SortsHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SortsHeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 20,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return collectionView
    }()

    init(viewModel: CategoryViewModelProtocol,
         layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        self.emptyResultView = EmptyOnScreenView(state: .noResult)
        self.viewModel = viewModel
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindUpdates()
        // Временное решение для обновления списка избранного на данном экране.
        categoryCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        visibleCancellables.removeAll()
    }

    private func setupViews() {
        view.backgroundColor = .cherryLightBlue

        [categoryCollectionView, emptyResultView, progressView].forEach { view.addSubview($0) }
        emptyResultView.isHidden = true // Скрыть по умолчанию

        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyResultView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindUpdates() {
        viewModel.productsUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] itemCount in
                guard let self = self else { return }
                addItems(newCount: itemCount)
                self.progressView.stopAnimating()
            }
            .store(in: &visibleCancellables)

        viewModel.viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.updateUI(for: state)
            }
            .store(in: &visibleCancellables)
    }

    private func setupBindings() {
        emptyResultView.mainButtonTappedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.navigateToMainScreen()
            }
            .store(in: &cancellables)

        viewModel.loadNextPage()
    }

    private func updateUI(for state: ViewState) {
        let isDataPresent = state == .dataPresent
        categoryCollectionView.isHidden = !isDataPresent
        emptyResultView.isHidden = isDataPresent

        if state == .loading {
            categoryCollectionView.isHidden = true
            emptyResultView.isHidden = true
            progressView.startAnimating()
        }
    }

    private func addItems(newCount: Int, to section: Int = 0) {
        let currentItemCount = categoryCollectionView.numberOfItems(inSection: section)
        let newCellPaths = (currentItemCount..<newCount).map {
            IndexPath(row: $0, section: section)
        }
        self.categoryCollectionView.performBatchUpdates {
        self.categoryCollectionView.insertItems(at: newCellPaths)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Обработка заголовка
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: SortsHeaderView.reuseIdentifier,
                                                                               for: indexPath) as? SortsHeaderView
            else {
                return UICollectionReusableView()
            }

            let headerName = viewModel.getTitle()
            header.configure(with: headerName)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            // Обработка подвала
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: FooterView.reuseIdentifier,
                                                                               for: indexPath) as? FooterView
            else {
                return UICollectionReusableView()
            }

            return footer
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier,
                                                            for: indexPath) as? ProductCell
        else {
            return UICollectionViewCell()
        }

        cell.cancellable = cell.likeButtonTappedPublisher
            .sink { [weak self] productID in
                guard let self = self else { return }
                self.viewModel.likeButtonTapped(for: productID)
            }

        let product = viewModel.getProduct(for: indexPath.row)
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uiModel = viewModel.getProduct(for: indexPath.row)
        if let product = viewModel.getProductById(uiModel.id) {
            coordinator?.navigateToProductScreen(for: product)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 4 {
            viewModel.loadNextPage()
        }
    }
}

// MARK: - Search field delegate
extension CategoryViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        coordinator?.navigateToSearchScreen()
    }
}
