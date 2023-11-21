import UIKit

class CollectionLayoutProvider {
    func createLayoutForMainScreen() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            // Возвращаем различные макеты секций в зависимости от индекса секции
            return self?.createSectionLayout(for: sectionIndex)
        }
    }

    private func createSectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        // Настройка размеров элемента в зависимости от секции
        let itemHeight: CGFloat = (sectionIndex == 0) ? 32 : 228

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
