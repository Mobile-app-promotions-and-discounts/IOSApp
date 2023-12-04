//
//  ProductTitleCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import UIKit

class ProductTitleCell: UICollectionViewCell {
    // UI элементы для названия и веса товара

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Настройка внешнего вида ячейки
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String, weight: String) {
        // Конфигурация ячейки с названием и весом товара
    }
}
