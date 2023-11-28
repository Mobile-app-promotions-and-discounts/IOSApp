import UIKit
import SnapKit
import Combine

final class MainViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: MainViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private var cancellables = Set<AnyCancellable>()

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
        collectionView.contentInset = UIEdgeInsets(top: CornerRadius.regular.cgFloat(),
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
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
        setupBindings()
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

    private func setupBindings() {
        // Подписка на обновления категорий
        viewModel.categoriesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)

        // Подписка на обновления продуктов
        viewModel.productsUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)

        // Подписка на обновления магазинов
        viewModel.storesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mainSection = MainSection(rawValue: section) else { return 0 }
        return viewModel.numberOfItems(inSection: mainSection)
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

        guard let mainSection = MainSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch mainSection {
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCell.reuseIdentifier,
                                                                for: indexPath) as? FiltersCell else {
                return UICollectionViewCell()
            }

            let title = viewModel.getTitleFor(indexPath: indexPath)
            cell.configure(with: title)
            return cell

        case .promotions:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.reuseIdentifier,
                                                                for: indexPath) as? PromotionCell else {
                return UICollectionViewCell()
            }
            let promotion = viewModel.getPromotion(for: indexPath.row)
            cell.configure(with: promotion)
            return cell
        case .stores:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoresCell.reuseIdentifier,
                                                                for: indexPath) as? StoresCell else {
                return UICollectionViewCell()
            }
            let store = viewModel.getStore(for: indexPath.row)
            cell.configure(with: store)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.coordinator?.navigateToCategoryScreen()
        } else {
            print("Для других ячеек обработка нажатия будет реализована позже")
        }
    }
}
