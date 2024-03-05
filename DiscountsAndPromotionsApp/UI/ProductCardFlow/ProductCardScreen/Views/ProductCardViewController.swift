import UIKit

final class ProductCardViewController: UIViewController {
    weak var coordinator: Coordinator?

    private let viewModel: ProductCardViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    private var originalNavBarAppearance: UINavigationBarAppearance?

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
        //        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.reuseIdentifier)
        //        collectionView.register(MainHeaderView.self,
        //                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        //                                withReuseIdentifier: MainHeaderView.reuseIdentifier)
        //        collectionView.register(FooterView.self,
        //                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
        //                                withReuseIdentifier: FooterView.reuseIdentifier)
        //        collectionView.register(StoresCell.self, forCellWithReuseIdentifier: StoresCell.reuseIdentifier)
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
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
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cardSection = ProductCardSections(rawValue: indexPath.row) else {
            return UICollectionViewCell()
        }

        switch cardSection {
        case .imageAndDescription:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.reuseIdentifier,
                                                                for: indexPath) as? ProductImageCell,
                let productUIModel = viewModel.getUIModel()
            else {
                fatalError("Unable to dequeue ProductImageCell")

            }
            cell.configure(with: productUIModel)
            return cell
        case .storeOffers:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.reuseIdentifier,
                                                                for: indexPath) as? ProductImageCell else {
                fatalError("Unable to dequeue ProductImageCell")

            }
            return cell
        case .reviews:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.reuseIdentifier,
                                                                for: indexPath) as? ProductImageCell else {
                fatalError("Unable to dequeue ProductImageCell")

            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductCardViewController: UICollectionViewDelegateFlowLayout {}
