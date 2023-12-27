import UIKit
import Combine
import SnapKit

final class FavoritesViewController: ScannerEnabledViewController {
    weak var coordinator: FavoritesScreenCoordinator?

    private let viewModel: FavoritesViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    private let emptyResultView: EmptyOnScreenView

    private var cancellables = Set<AnyCancellable>()

    private lazy var favoritesCollectionView: UICollectionView = {
        let layout = layoutProvider.createGoodsScreensLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(SortsHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SortsHeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 12,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return collectionView
    }()

    init(viewModel: FavoritesViewModelProtocol,
         layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        self.emptyResultView = EmptyOnScreenView(state: .noFavorites)
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

    private func setupViews() {
        // ToDo: цвет фона временный, для отладки
        view.backgroundColor = .cherryLightBlue

        view.addSubview(favoritesCollectionView)

        favoritesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.favoriteProductsUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.favoritesCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.updateUI(for: state)
            }
            .store(in: &cancellables)
    }

    private func updateUI(for state: ViewState) {
        let isDataPresent = state == .dataPresent
        favoritesCollectionView.isHidden = !isDataPresent
        emptyResultView.isHidden = isDataPresent

        if state == .loading {
            // Показать индикатор загрузки, если необходимо
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
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

            let headerName = viewModel.getTitleForHeader()
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
            ErrorHandler.handle(error: .customError("Ошибка получения cell"))
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

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uiModel = viewModel.getProduct(for: indexPath.row)
        if let product = viewModel.getProductById(uiModel.id) {
        coordinator?.navigateToFavoriteProductScreen(for: product)
        }
    }
}
