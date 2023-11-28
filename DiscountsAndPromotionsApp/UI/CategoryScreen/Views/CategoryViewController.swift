import UIKit
import SnapKit

final class CategoryViewController: CoordinatedViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: CategoryViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    init(viewModel: CategoryViewModelProtocol, layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        self.viewModel = viewModel
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        layoutProvider.createLayoutForCategoryScreen(for: categoryCollectionView, in: view)
        // ToDo: цвет фона временный, для отладки
        view.backgroundColor = .mainBG

        view.addSubview(categoryCollectionView)

        categoryCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productsList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                            for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }

        let product = viewModel.getProduct(for: indexPath.row)
        cell.configure(with: product)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryViewController: UICollectionViewDelegate {}
