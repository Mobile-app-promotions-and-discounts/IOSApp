//
//  ProductCardViewController.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import UIKit

class ProductCardViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case gallery
        case title
        case rating
        case stores
        case review
        case priceInfo
    }

    var product: ProductModel?
    weak var coordinator: MainCoordinator?

    private var collectionView: UICollectionView!

    init(product: ProductModel) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self

        // Регистрация кастомных ячеек
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: "ImageGalleryCell")
        collectionView.register(ProductTitleCell.self, forCellWithReuseIdentifier: "ProductTitleCell")
        collectionView.register(RatingCell.self, forCellWithReuseIdentifier: "RatingCell")
        collectionView.register(StoreCell.self, forCellWithReuseIdentifier: "StoreCell")
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: "ReviewCell")
        collectionView.register(PriceInfoCell.self, forCellWithReuseIdentifier: "PriceInfoCell")

        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .gallery:
                return self.createGallerySection()
            default:
                return self.createDefaultSection()
            }

        }
    }

    private func createGallerySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }

    private func createDefaultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            return NSCollectionLayoutSection(group: group)
    }
}

extension ProductCardViewController: UICollectionViewDataSource {

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return Section.allCases.count
//    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }

        switch sectionType {
        case .gallery:
            return product?.image?.count ?? 0
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
        case .gallery:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.identifier, for: indexPath) as? ImageGalleryCell else {
                        return UICollectionViewCell() // Возвращаем базовую ячейку, если приведение типа не удалось
                    }

            if let imageName = product?.image, let image = UIImage(named: imageName) {
                cell.configure(with: image)
            } else {
                cell.configure(with: UIImage(named: "placeholder")!)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }

}

extension ProductCardViewController: UICollectionViewDelegate {

}
