import UIKit
import SnapKit
import Combine

final class MainViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: MainViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider

    private var cancellables = Set<AnyCancellable>()

    private lazy var mainCollectionView: UICollectionView = {
        let layout = layoutProvider.createMainScreenLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.reuseIdentifier)
        collectionView.register(MainHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainHeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
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
        setupViews()
        setupBindings()
        viewModel.viewDidLoad()
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cherryLightBlue

        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }

    private func setupBindings() {
        // Подписка на обновления категорий
        viewModel.categoriesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let sectionIndex = MainSection.categories.rawValue
                self.mainCollectionView.reloadSections(IndexSet(integer: sectionIndex))
            }
            .store(in: &cancellables)

        // Подписка на обновления продуктов
        viewModel.productsUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let sectionIndex = MainSection.promotions.rawValue
                self.mainCollectionView.reloadSections(IndexSet(integer: sectionIndex))
            }
            .store(in: &cancellables)

        // Подписка на обновления магазинов
        viewModel.storesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let sectionIndex = MainSection.stores.rawValue
                self.mainCollectionView.reloadSections(IndexSet(integer: sectionIndex))
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
        if kind == UICollectionView.elementKindSectionHeader {
            // Обработка заголовка
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: MainHeaderView.reuseIdentifier,
                                                                               for: indexPath) as? MainHeaderView else {
                return UICollectionReusableView()
            }

            guard let mainSection = MainSection(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            header.cancellable = header.allButtonTapped
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.coordinator?.navigateToAllDetailsScreen(with: mainSection)
                }

            let headerName = viewModel.getTitleFor(section: mainSection)
            header.configure(with: headerName)

            if mainSection == .promotions {
                header.isUserInteractionEnabled = viewModel.didFetchProducts
            }

            if mainSection == .stores {
                header.isUserInteractionEnabled = viewModel.didFetchStores
            }

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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let mainSection = MainSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch mainSection {
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                                for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            guard let category = viewModel.getCategoryUIModel(for: indexPath.row) else {
                return cell
            }
            cell.configure(with: category)
            return cell

        case .promotions:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.reuseIdentifier,
                                                                for: indexPath) as? PromotionCell else {
                return UICollectionViewCell()
            }
            guard let promotion = viewModel.getPromotion(for: indexPath.row)
            else {
                return cell
            }
            cell.configure(with: promotion)
            return cell
        case .stores:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoresCell.reuseIdentifier,
                                                                for: indexPath) as? StoresCell else {
                return UICollectionViewCell()
            }
            if let store = viewModel.getStore(for: indexPath.row) {
                cell.configure(with: store)
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0,
           let category = viewModel.getCategory(for: indexPath.row) {
            self.coordinator?.navigateToCategoryScreen(with: category)
        } else if indexPath.section == 1,
                  let product = viewModel.getProduct(for: indexPath.row) {
            self.coordinator?.navigateToProductScreen(for: product)
        } else {
            print("Для других ячеек обработка нажатия будет реализована позже")
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        coordinator?.navigateToSearchScreen()
    }
}
