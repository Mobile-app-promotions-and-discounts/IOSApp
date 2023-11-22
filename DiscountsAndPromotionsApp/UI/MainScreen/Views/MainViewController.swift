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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersCell.reuseIdentifier,
                                                            for: indexPath) as? FiltersCell else {
            return UICollectionViewCell()
        }

        let title = viewModel.getTitleForItemAt(indexPath: indexPath)
        cell.configure(with: title)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.coordinator?.navigateToCategoryScreen()
        default:
            print("Будет реализовано позже")
        }
    }
}
