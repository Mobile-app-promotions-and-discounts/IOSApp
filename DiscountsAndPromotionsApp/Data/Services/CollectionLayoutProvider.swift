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
        // Настройка размеров элемента в зависимости от секции
        let itemHeight: CGFloat = (sectionIndex == 0) ? 40 : 228

        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1000),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
}
