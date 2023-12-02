import UIKit
import Combine
import SnapKit

final class FavoritesViewController: UIViewController {
    weak var coordinator: FavoritesScreenCoordinator?

    private let viewModel: FavoritesViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private var cancellables = Set<AnyCancellable>()

    private lazy var favoritesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    init(viewModel: FavoritesViewModelProtocol, layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
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
        layoutProvider.createCategoryScreenLayout(for: favoritesCollectionView, in: view)
        // ToDo: цвет фона временный, для отладки
        view.backgroundColor = .cherryLightBlue

        view.addSubview(favoritesCollectionView)

        favoritesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                           for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        let headerName = viewModel.getTitleForHeader()
        header.configure(with: headerName)
        return header
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
