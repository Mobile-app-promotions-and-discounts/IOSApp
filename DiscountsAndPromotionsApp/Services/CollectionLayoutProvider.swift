import UIKit

final class CollectionLayoutProvider {
    private struct Constants {
        static let numberOfItemsPerRow: CGFloat = 3
        static let spacing: CGFloat = 13
        static let sectionInset: CGFloat = 16
        static let interGroupSpacing: CGFloat = 8
        static let promoAspectRatio: CGFloat = 106 / 112
        static let shopsAspectRatio: CGFloat = 106 / 68
        static let itemHeight: CGFloat = 243
        static let headerHeight: CGFloat = 44
        static let footerHeight: CGFloat = 12
    }

    func createMainScreenLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (mainSection, environment) -> NSCollectionLayoutSection? in
            guard let self,
                  let mainSection = MainSection(rawValue: mainSection)
            else { return nil }
            return self.createSectionLayout(for: mainSection, environment: environment)
        }
        // Регистрация кастомного вью для фоновой заливки секции
        layout.register(SectionBackgroundView.self,
                        forDecorationViewOfKind: NSStringFromClass(SectionBackgroundView.self))
        return layout
    }

    func createCategoryScreenLayout(for collectionView: UICollectionView, in view: UIView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let totalSpacing = Constants.spacing * 3
        let itemWidth = (view.bounds.width - totalSpacing) / 2

        layout.itemSize = CGSize(width: itemWidth, height: Constants.itemHeight)
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
    }

    private func createSectionLayout(for section: MainSection,
                                     environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let newSection: NSCollectionLayoutSection
        switch section {
        case .categories:
            newSection = createCategoriesSection()
        case .promotions:
            newSection = createConfigurableSection(environment: environment, aspectRatio: Constants.promoAspectRatio)
        case .stores:
            newSection = createConfigurableSection(environment: environment, aspectRatio: Constants.shopsAspectRatio)
        }
        return newSection
    }

    private func createCategoriesSection() -> NSCollectionLayoutSection {
        // Элементы для первых двух строк
        let firstTwoRowsItemSize = NSCollectionLayoutSize(widthDimension: .absolute(166),
                                                          heightDimension: .absolute(74))
        let firstTwoRowsItem = NSCollectionLayoutItem(layoutSize: firstTwoRowsItemSize)
        let firstTwoRowsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .absolute(80))
        let firstTwoRowsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: firstTwoRowsGroupSize,
                                                                   subitem: firstTwoRowsItem, count: 2)
        firstTwoRowsGroup.interItemSpacing = .fixed(Constants.spacing)

        // Элементы для третьей строки
        let thirdRowItemSize = NSCollectionLayoutSize(widthDimension: .absolute(77),
                                                      heightDimension: .absolute(59))
        let thirdRowItem = NSCollectionLayoutItem(layoutSize: thirdRowItemSize)
        let thirdRowGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(66))
        let thirdRowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: thirdRowGroupSize,
                                                               subitem: thirdRowItem, count: 4)
        thirdRowGroup.interItemSpacing = .fixed(Constants.spacing)

        // Общая группа, объединяющая все строки
        let combinedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(206))
        let combinedGroup = NSCollectionLayoutGroup.vertical(layoutSize: combinedGroupSize,
                                                             subitems: [firstTwoRowsGroup,
                                                                        firstTwoRowsGroup,
                                                                        thirdRowGroup])
        combinedGroup.interItemSpacing = .fixed(Constants.interGroupSpacing)

        let section = NSCollectionLayoutSection(group: combinedGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 6, trailing: 16)
        section.orthogonalScrollingBehavior = .none

        return section
    }

    private func createConfigurableSection(environment: NSCollectionLayoutEnvironment,
                                           aspectRatio: CGFloat) -> NSCollectionLayoutSection {
        let containerWidth = environment.container.effectiveContentSize.width
        let totalSpacingBetweenItems = (Constants.numberOfItemsPerRow - 1) * Constants.spacing
        let totalInsets = Constants.sectionInset * 2
        let adjustedWidth = containerWidth - totalSpacingBetweenItems - totalInsets
        let itemWidth = adjustedWidth / Constants.numberOfItemsPerRow

        let itemAspectRatio = aspectRatio
        let itemHeight = itemWidth / itemAspectRatio

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth * Constants.numberOfItemsPerRow + totalSpacingBetweenItems),
                                               heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: Int(Constants.numberOfItemsPerRow))
        group.interItemSpacing = .fixed(Constants.spacing)

        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: NSStringFromClass(SectionBackgroundView.self)
        )

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(Constants.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = Constants.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: Constants.sectionInset,
                                                        bottom: 12,
                                                        trailing: Constants.sectionInset)
        section.orthogonalScrollingBehavior = .none
        section.decorationItems = [backgroundDecoration]

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.footerHeight))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        section.boundarySupplementaryItems.append(footer)

        return section
    }
}
