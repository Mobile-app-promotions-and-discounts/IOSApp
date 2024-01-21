import UIKit

private struct Constants {
    // Общие константы для компоновки
    static let twoNumberOfItemsPerRow: CGFloat = 2
    static let threeNumberOfItemsPerRow: CGFloat = 3

    static let spacing: CGFloat = 13
    static let sectionInset: CGFloat = 16
    static let interGroupSpacing: CGFloat = 8

    // Размеры вспомогательных элементов
    static let headerHeight: CGFloat = 44
    static let footerHeight: CGFloat = 12

    // Соотношения сторон
    static let promoAspectRatio: CGFloat = 106 / 112
    static let shopsAspectRatio: CGFloat = 106 / 68
    static let goodsAspectRatio: CGFloat = 165 / 212

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
    static let itemHeight: CGFloat = 232
}

final class CollectionLayoutProvider {
    // Функция создания макета для основного экрана
    func createMainScreenLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, environment) ->
            NSCollectionLayoutSection? in
            guard
                let self = self,
                let mainSection = MainSection(rawValue: sectionIndex) else {
                return nil
            }
            switch mainSection {
            case .categories:
                // Специальная логика для секции категорий
                return self.createCategoriesSection()
            case .promotions:
                // Создание секции для акций
                return self.createSection(environment: environment,
                                          aspectRatio: Constants.promoAspectRatio,
                                          itemsPerRow: Constants.threeNumberOfItemsPerRow)
            case .stores:
                // Создание секции для магазинов
                return self.createSection(environment: environment,
                                          aspectRatio: Constants.shopsAspectRatio,
                                          itemsPerRow: Constants.threeNumberOfItemsPerRow)
            }
        }
        // Регистрация кастомного вида для фоновой заливки секции
        layout.register(SectionBackgroundView.self,
                        forDecorationViewOfKind: NSStringFromClass(SectionBackgroundView.self))
        return layout
    }

    // Функция создания макета для экрана с товарами
    func createGoodsScreensLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (_, environment) ->
            NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createSection(environment: environment,
                                      aspectRatio: Constants.goodsAspectRatio,
                                      itemsPerRow: Constants.twoNumberOfItemsPerRow)
        }
        // Регистрация кастомного вида для фоновой заливки секции
        layout.register(SectionBackgroundView.self,
                        forDecorationViewOfKind: NSStringFromClass(SectionBackgroundView.self))
        return layout
    }

    // Функция создания макета для экрана со всеми магазинами
    func createAllStoresScreenLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (_, environment) ->
            NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createSection(environment: environment,
                                      aspectRatio: Constants.shopsAspectRatio,
                                      itemsPerRow: Constants.threeNumberOfItemsPerRow)
        }
        // Регистрация кастомного вида для фоновой заливки секции
        layout.register(SectionBackgroundView.self,
                        forDecorationViewOfKind: NSStringFromClass(SectionBackgroundView.self))
        return layout
    }

    // Создание секции категорий
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
                                                             subitems: [firstTwoRowsGroup,
                                                                        firstTwoRowsGroup,
                                                                        thirdRowGroup])
        combinedGroup.interItemSpacing = .fixed(Constants.interGroupSpacing)

        let section = NSCollectionLayoutSection(group: combinedGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.sectionTopInset,
                                                        leading: Constants.sectionInset,
                                                        bottom: Constants.sectionBottomInset,
                                                        trailing: Constants.sectionInset)
        section.orthogonalScrollingBehavior = .none

        return section
    }

    // Универсальная функция для создания стандартной секции
    private func createSection(environment: NSCollectionLayoutEnvironment,
                               aspectRatio: CGFloat,
                               itemsPerRow: CGFloat,
                               orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none) -> NSCollectionLayoutSection {
        let itemWidth = calculateItemWidth(containerWidth: environment.container.effectiveContentSize.width, numberPerRow: itemsPerRow)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                              heightDimension: .absolute(itemWidth / aspectRatio))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemSize.heightDimension.dimension)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Int(itemsPerRow))
        group.interItemSpacing = .fixed(Constants.spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: Constants.sectionInset, bottom: 12, trailing: Constants.sectionInset)
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior

        // Декоративный элемент и границы секции
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: NSStringFromClass(SectionBackgroundView.self)
        )
        section.decorationItems = [backgroundDecoration]

        // Добавляем заголовок и подвал
        addBoundarySupplementaryItems(to: section)

        return section
    }

    // Функция добавления заголовка и подвала к секции
    private func addBoundarySupplementaryItems(to section: NSCollectionLayoutSection) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(Constants.headerHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems.append(header)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(Constants.footerHeight))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        section.boundarySupplementaryItems.append(footer)
    }

    // Вспомогательная функция для вычисления ширины элемента
    private func calculateItemWidth(containerWidth: CGFloat, numberPerRow: CGFloat) -> CGFloat {
        let totalSpacing = (numberPerRow - 1) * Constants.spacing + Constants.sectionInset * 2
        return (containerWidth - totalSpacing) / numberPerRow
    }
}
