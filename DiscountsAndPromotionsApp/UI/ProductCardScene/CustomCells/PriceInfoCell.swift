//
//  FavoriteCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import UIKit

class PriceInfoCell: UICollectionViewCell {
    // UI элементы для отображения информации о цене и кнопки "В избранное"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Настройка внешнего вида ячейки
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with price: Double, discountPrice: Double) {
        // Конфигурация ячейки с информацией о цене
    }
}
