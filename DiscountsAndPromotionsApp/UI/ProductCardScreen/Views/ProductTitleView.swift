//
//  ProductTitleCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit

class ProductTitleView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(weightLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            weightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            weightLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with title: String, weight: String) {
        titleLabel.text = title
        weightLabel.text = weight
    }
}
