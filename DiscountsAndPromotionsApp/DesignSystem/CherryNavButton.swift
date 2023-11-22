//
//  CherryNavButton.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 21.11.2023.
//

import UIKit

class CherryNavButton: UIButton {
    override var isSelected: Bool {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemBackground
        layer.cornerRadius = 22
        clipsToBounds = true
    }

}
