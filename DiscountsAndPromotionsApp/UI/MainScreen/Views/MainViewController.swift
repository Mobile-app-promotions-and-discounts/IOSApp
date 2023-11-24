import UIKit
import SnapKit

final class MainViewController: UIViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: MainViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private lazy var mainCollectionView: UICollectionView = {
        let layout = layoutProvider.createLayoutForMainScreen()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FiltersCell.self, forCellWithReuseIdentifier: FiltersCell.reuseIdentifier)
        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.reuseIdentifier)
        collectionView.register(PromotionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PromotionHeader.reuseIdentifier)
        collectionView.register(StoresCell.self, forCellWithReuseIdentifier: StoresCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    init(viewModel: MainViewModelProtocol, layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
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
        // ToDo: цвет фона временный, для отладки
        view.backgroundColor = UIColor.mainBG

        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: PromotionHeader.reuseIdentifier,
                                                                           for: indexPath) as? PromotionHeader else {
            return UICollectionReusableView()
        }
        let headerName = viewModel.getTitleFor(indexPath: indexPath)
        header.configure(with: headerName)
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCell.reuseIdentifier,
                                                                for: indexPath) as? FiltersCell else {
                return UICollectionViewCell()
            }

            let title = viewModel.getTitleFor(indexPath: indexPath)
            cell.configure(with: title)
            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.reuseIdentifier,
                                                                for: indexPath) as? PromotionCell else {
                return UICollectionViewCell()
            }
            let promotion = viewModel.getPromotion(for: indexPath.row)
            cell.configure(with: promotion)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoresCell.reuseIdentifier,
                                                                for: indexPath) as? StoresCell else {
                return UICollectionViewCell()
            }
            let store = viewModel.getStore(for: indexPath.row)
            cell.configure(with: store)
            return cell

        default:
            print("default - UICollectionViewCell")
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.coordinator?.navigateToCategoryScreen()
        } else if indexPath.section == 1 {
            let promotionUIModel = viewModel.getPromotion(for: indexPath.row)
            coordinator?.navigateToProductScreen(for: promotionUIModel.product)
        } else {
            print("Для других ячеек обработка нажатия будет реализована позже")
        }
    }
}
