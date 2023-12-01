import UIKit

final class CollectionLayoutProvider {
    func createLayoutForMainScreen() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return self.createSectionLayout(for: sectionIndex, environment: environment)
        }

        // Регистрация класса фона для декоративного элемента
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: NSStringFromClass(SectionBackgroundView.self))

        return layout
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

    private func createSectionLayout(for sectionIndex: Int,
                                     environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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

        case 2:
            // Размер заголовка остается прежним
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            // Расчеты размеров элемента с учетом отступов
            let spacing: CGFloat = 12 // Пространство между элементами
            let sectionInset: CGFloat = 16 // Отступы секции слева и справа
            let containerWidth = environment.container.effectiveContentSize.width
            let numberOfItemsPerRow: CGFloat = 3
            let totalSpacingBetweenItems = (numberOfItemsPerRow - 1) * spacing
            let totalInsets = sectionInset * 2
            let adjustedWidth = containerWidth - totalSpacingBetweenItems - totalInsets
            let itemWidth = adjustedWidth / numberOfItemsPerRow

            // Аспектное соотношение для элемента
            let itemAspectRatio: CGFloat = 106 / 68
            let itemHeight = itemWidth / itemAspectRatio

            // Создание размера элемента с учетом аспектного соотношения
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                                  heightDimension: .absolute(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Создание группы для горизонтального расположения элементов
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth * numberOfItemsPerRow + totalSpacingBetweenItems),
                                                   heightDimension: .absolute(itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: Int(numberOfItemsPerRow))
            group.interItemSpacing = .fixed(spacing)

            // Создание декоративного элемента для фона секции
            let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: NSStringFromClass(SectionBackgroundView.self)
            )

            // Создание секции
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                            leading: sectionInset,
                                                            bottom: 12,
                                                            trailing: sectionInset)
            section.orthogonalScrollingBehavior = .none
            section.decorationItems = [backgroundDecoration]

            return section

        default:
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(44)) // Примерная высота заголовка

            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)

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
