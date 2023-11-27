import UIKit

final class CollectionLayoutProvider {
    func createLayoutForMainScreen() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createSectionLayout(for: sectionIndex)
        }
    }

    func createLayoutForCategoryScreen(for collectionView: UICollectionView, in view: UIView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let spacing: CGFloat = 12
        let totalSpacing = spacing * 3
        let itemWidth = (view.bounds.width - totalSpacing) / 2

        layout.itemSize = CGSize(width: itemWidth, height: 243)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch sectionIndex {
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                  heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000),
                                                   heightDimension: .absolute(40))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 18, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous

            return section

        default:
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44)) // Примерная высота заголовка

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(216),
                                                  heightDimension: .absolute(228))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(216),
                                                   heightDimension: .absolute(228))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 18, trailing: 0)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

            return section
        }
    }
}
