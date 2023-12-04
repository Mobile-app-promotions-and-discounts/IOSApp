import UIKit

private struct Constants {
    // Общие константы для компоновки
    static let numberOfItemsPerRow: CGFloat = 3
    static let spacing: CGFloat = 13
    static let sectionInset: CGFloat = 16
    static let interGroupSpacing: CGFloat = 8

    // Размеры вспомогательных элементов
    static let headerHeight: CGFloat = 44
    static let footerHeight: CGFloat = 12

    // Соотношения сторон
    static let promoAspectRatio: CGFloat = 106 / 112
    static let shopsAspectRatio: CGFloat = 106 / 68

    // Константы для секции категорий
    static let itemWidthForFirstTwoRows: CGFloat = 166
    static let itemHeightForFirstTwoRows: CGFloat = 74
    static let groupHeightForFirstTwoRows: CGFloat = 80

    static let itemWidthForThirdRow: CGFloat = 77
    static let itemHeightForThirdRow: CGFloat = 59
    static let groupHeightForThirdRow: CGFloat = 66
    static let combinedGroupHeight: CGFloat = 206

    // Отступы для секций
    static let sectionTopInset: CGFloat = 18
    static let sectionBottomInset: CGFloat = 6

    // Размеры элементов
    static let itemHeight: CGFloat = 243
}

final class CollectionLayoutProvider {
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
        case .promotions, .stores:
            let aspectRatio = section == .promotions ? Constants.promoAspectRatio : Constants.shopsAspectRatio
            return createConfigurableSection(environment: environment, aspectRatio: aspectRatio)
        }
        return newSection
    }

    private func createCategoriesSection() -> NSCollectionLayoutSection {
        // Элементы для первых двух строк
        let firstTwoRowsItemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.itemWidthForFirstTwoRows),
                                                          heightDimension: .absolute(Constants.itemHeightForFirstTwoRows))
        let firstTwoRowsItem = NSCollectionLayoutItem(layoutSize: firstTwoRowsItemSize)
        let firstTwoRowsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .absolute(Constants.groupHeightForFirstTwoRows))
        let firstTwoRowsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: firstTwoRowsGroupSize,
                                                                   subitem: firstTwoRowsItem,
                                                                   count: 2)
        firstTwoRowsGroup.interItemSpacing = .fixed(Constants.spacing)

        // Элементы для третьей строки
        let thirdRowItemSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.itemWidthForThirdRow),
                                                      heightDimension: .absolute(Constants.itemHeightForThirdRow))
        let thirdRowItem = NSCollectionLayoutItem(layoutSize: thirdRowItemSize)
        let thirdRowGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(Constants.groupHeightForThirdRow))
        let thirdRowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: thirdRowGroupSize,
                                                               subitem: thirdRowItem,
                                                               count: 4)
        thirdRowGroup.interItemSpacing = .fixed(Constants.spacing)

        // Общая группа, объединяющая все строки
        let combinedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(Constants.combinedGroupHeight))
        let combinedGroup = NSCollectionLayoutGroup.vertical(layoutSize: combinedGroupSize,
                                                             subitems: [firstTwoRowsGroup, firstTwoRowsGroup, thirdRowGroup])
        combinedGroup.interItemSpacing = .fixed(Constants.interGroupSpacing)

        let section = NSCollectionLayoutSection(group: combinedGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.sectionTopInset,
                                                        leading: Constants.sectionInset,
                                                        bottom: Constants.sectionBottomInset,
                                                        trailing: Constants.sectionInset)
        section.orthogonalScrollingBehavior = .none

        return section
    }

    private func createConfigurableSection(environment: NSCollectionLayoutEnvironment,
                                           aspectRatio: CGFloat) -> NSCollectionLayoutSection {
        // Вычисление ширины каждого элемента в секции
        let itemWidth = calculateItemWidth(containerWidth: environment.container.effectiveContentSize.width)
        let itemHeight = itemWidth / aspectRatio

        // Создание размера элемента с использованием рассчитанных ширины и высоты
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                              heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Определение размера группы, которая будет содержать элементы
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth * Constants.numberOfItemsPerRow + (Constants.numberOfItemsPerRow - 1) * Constants.spacing),
            heightDimension: .absolute(itemHeight)
        )

        // Создание группы с определенным количеством элементов в ряду
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: Int(Constants.numberOfItemsPerRow))
        group.interItemSpacing = .fixed(Constants.spacing)

        // Добавление декоративного элемента для фона секции
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: NSStringFromClass(SectionBackgroundView.self)
        )

        // Создание заголовка секции
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(Constants.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        // Создание самой секции с группой элементов
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = Constants.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: Constants.sectionInset,
                                                        bottom: 12,
                                                        trailing: Constants.sectionInset)
        section.orthogonalScrollingBehavior = .none
        section.decorationItems = [backgroundDecoration]

        // Добавление подвала (футера) секции
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(Constants.footerHeight))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        section.boundarySupplementaryItems.append(footer)

        return section
    }

    private func calculateItemWidth(containerWidth: CGFloat) -> CGFloat {
        let totalSpacing = (Constants.numberOfItemsPerRow - 1) * Constants.spacing + Constants.sectionInset * 2
        return (containerWidth - totalSpacing) / Constants.numberOfItemsPerRow
    }
}
