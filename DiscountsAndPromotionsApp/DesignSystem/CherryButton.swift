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
        backgroundColor = isSelected ? .tintColor : .systemBackground
        titleLabel?.textColor = isSelected ? .systemBackground : .tintColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
