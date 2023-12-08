import UIKit
import SnapKit
import Combine

final class CategoryViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: CategoryViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private var cancellables = Set<AnyCancellable>()

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
        collectionView.contentInset = UIEdgeInsets(top: 12,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return collectionView
    }()

    init(viewModel: CategoryViewModelProtocol,
         layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
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
        // Временное решение для обновления списка избранного на данном экране.
        categoryCollectionView.reloadData()
    }

    private func setupViews() {
        view.backgroundColor = .cherryLightBlue

        view.addSubview(categoryCollectionView)

        categoryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.productsUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.categoryCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Обработка заголовка
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: SortsHeaderView.reuseIdentifier,
                                                                               for: indexPath) as? SortsHeaderView else {
                return UICollectionReusableView()
            }

            let headerName = viewModel.getTitle()
            header.configure(with: headerName)
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            // Обработка подвала
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: FooterView.reuseIdentifier,
                                                                               for: indexPath) as? FooterView else {
                return UICollectionReusableView()
            }

            return footer
        }

        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier,
                                                            for: indexPath) as? ProductCell else {
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

extension CategoryViewController: UICollectionViewDelegate {}

// MARK: - Search field delegate
extension CategoryViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        coordinator?.navigateToSearchScreen()
    }
}
