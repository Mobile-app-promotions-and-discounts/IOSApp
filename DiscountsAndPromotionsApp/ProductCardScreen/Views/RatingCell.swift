//
//  RatingCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit
class RatingCell: UICollectionViewCell {
    // UI элементы для рейтинга, средней оценки, количества отзывов и кнопки для перехода к отзывам

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Настройка внешнего вида ячейки
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rating: Double, numberOfReviews: Int) {
        // Конфигурация ячейки с рейтингом и отзывами
    }
}
