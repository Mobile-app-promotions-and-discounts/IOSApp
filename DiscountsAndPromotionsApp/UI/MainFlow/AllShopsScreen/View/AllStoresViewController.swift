import UIKit

final class AllStoresViewController: ScannerEnabledViewController {
    weak var coordinator: MainScreenCoordinator?

    private let viewModel: AllShopsViewModelProtocol
    private let layoutProvider: CollectionLayoutProvider
    
    private lazy var storesCollectionView: UICollectionView = {
        let layout = layoutProvider.createAllStoresScreenLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()

    init(viewModel: AllShopsViewModelProtocol, layoutProvider: CollectionLayoutProvider = CollectionLayoutProvider()) {
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
//        setupBindings()
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

        mainCollectionView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
}
