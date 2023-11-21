//
//  CherryButton.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 21.11.2023.
//

import UIKit

class CherryButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = isSelected ? .systemFill : .systemBackground
        titleLabel?.textColor = isSelected ? .systemBackground : .systemFill
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
