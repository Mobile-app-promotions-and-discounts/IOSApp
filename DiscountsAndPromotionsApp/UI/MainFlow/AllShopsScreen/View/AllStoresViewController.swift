import UIKit
import Combine

final class AllStoresViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: AllStoresViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    private var cancellables = Set<AnyCancellable>()

    private lazy var storesCollectionView: UICollectionView = {
        let layout = layoutProvider.createAllStoresScreenLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SortsHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SortsHeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        collectionView.register(StoresCell.self, forCellWithReuseIdentifier: StoresCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 12,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return collectionView
    }()

    init(viewModel: AllStoresViewModelProtocol, layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
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
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

    private func setupViews() {
        view.backgroundColor = UIColor.cherryLightBlue

        view.addSubview(storesCollectionView)

        storesCollectionView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }

    private func setupBindings() {
        // Подписка на обновления магазинов
        viewModel.storesUpdate
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.storesCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension AllStoresViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoresCell.reuseIdentifier,
                                                            for: indexPath) as? StoresCell else {
            return UICollectionViewCell()
        }
        let store = viewModel.getStore(for: indexPath.row)
        cell.configure(with: store)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AllStoresViewController: UICollectionViewDelegate {

}
