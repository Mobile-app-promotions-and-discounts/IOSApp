import UIKit
import Combine

final class ProductCardViewController: UIViewController {
    weak var coordinator: ProductCardEnabledCoordinatorProtocol?

    private let viewModel: ProductCardViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    private var cancellables: Set<AnyCancellable> = []

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .cherryGray
        button.backgroundColor = .cherryWhite.withAlphaComponent(0.8)
        button.setImage(UIImage.icBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var exportButton: UIButton = {
        let button = UIButton()
        button.tintColor = .cherryGray
        button.backgroundColor = .cherryWhite.withAlphaComponent(0.8)
        button.layer.cornerRadius = 16
        button.setImage(UIImage.icExport, for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var productCardCollectionView: UICollectionView = {
        let layout = layoutProvider.createProductCardLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.reuseIdentifier)
        collectionView.register(ProductNameCell.self, forCellWithReuseIdentifier: ProductNameCell.reuseIdentifier)
        collectionView.register(ProductReviewsInfoCell.self, forCellWithReuseIdentifier: ProductReviewsInfoCell.reuseIdentifier)
        collectionView.register(ProductStoreOfferCell.self, forCellWithReuseIdentifier: ProductStoreOfferCell.reuseIdentifier)
        collectionView.register(ProductCardHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProductCardHeaderView.reuseIdentifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .cherryLightBlue
        collectionView.contentInset = UIEdgeInsets(top: view.safeAreaInsets.top,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return collectionView
    }()

    private let footerView = ProductCardFooterView()

    init(viewModel: ProductCardViewModelProtocol,
         layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
        self.viewModel = viewModel
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBindings() {
        viewModel.reviewsCountHasChanged
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.productCardCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @objc
    private func backButtonTapped() {
        coordinator?.navigateBack()
    }

    @objc
    private func sendButtonTapped() {
        print("Отправить другу")
    }

    private func setupViews() {
        view.backgroundColor = .cherryWhite
        [productCardCollectionView, backButton, exportButton, footerView].forEach { view.addSubview($0) }

        footerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(87)
        }

        productCardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(32)
        }

        exportButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.trailing.equalToSuperview().inset(16)
            make.height.width.equalTo(32)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductCardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productCardSection = ProductCardSections(rawValue: section) else {
            return 0
        }
        return viewModel.numberOfItems(inSection: productCardSection)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // Обработка заголовка
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: ProductCardHeaderView.reuseIdentifier,
                                                                               for: indexPath) as? ProductCardHeaderView else {
                return UICollectionReusableView()
            }

            guard let productSection = ProductCardSections(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }

            let headerName = viewModel.getTitleFor(section: productSection)
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
        guard let productCardSection = ProductCardSections(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        let cellTypes = viewModel.cellTypes(forSection: productCardSection)
        let cellType = cellTypes[indexPath.item]
        switch cellType {
        case .image(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.reuseIdentifier,
                                                                for: indexPath) as? ProductImageCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        case .name(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductNameCell.reuseIdentifier,
                                                                for: indexPath) as? ProductNameCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        case .reviewsInfo(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductReviewsInfoCell.reuseIdentifier,
                                                                for: indexPath) as? ProductReviewsInfoCell else {
                return UICollectionViewCell()
            }
            cell.cancellable = cell.openReviewsButtonTappedPublisher
                .sink { [weak self] in
                    guard let self = self else { return }
                    self.coordinator?.navigateToReviewsScreen(viewModel: viewModel)
                }
            cell.configure(with: model)
            return cell
        case .storeOffers:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductStoreOfferCell.reuseIdentifier,
                                                                for: indexPath) as? ProductStoreOfferCell else {
                return UICollectionViewCell()
            }
            let model = viewModel.getModelFor(item: indexPath.row)
            cell.configure(with: model)
            cell.cancellable = cell.openStoreSiteButtonTappedPublisher
                .sink(receiveValue: { [weak self] url in
                    guard let self = self else { return }
                    self.coordinator?.openURL(urlString: url)
                })
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductCardViewController: UICollectionViewDelegateFlowLayout {}
