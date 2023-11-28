//
//  PriceInfoView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit

protocol PriceInfoViewDelegate: AnyObject {
    func addToFavorites()
}

class PriceInfoView: UIView {

    weak var delegate: PriceInfoViewDelegate?
    private let toFavoritesButton = UIButton()
    private let worstOriginPrice = UILabel()
    private let bestDiscoutPrice = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with price: Double, discountPrice: Double) {
        worstOriginPrice.attributedText = NSAttributedString(
            string: String(price),
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )

        bestDiscoutPrice.text = "от \(discountPrice)р"

    }

    func setupLayout() {
        worstOriginPrice.textColor = .gray
        worstOriginPrice.font = .systemFont(ofSize: 14)
        worstOriginPrice.attributedText = NSAttributedString(
            string: "300р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )

        bestDiscoutPrice.textColor = .black
        bestDiscoutPrice.font = .boldSystemFont(ofSize: 24)
        bestDiscoutPrice.text = "от 150р"

        toFavoritesButton.setTitle("В Избранное", for: .normal)
        toFavoritesButton.backgroundColor = .lightGray
        toFavoritesButton.layer.cornerRadius = 10
        toFavoritesButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        toFavoritesButton.tintColor = .black
        toFavoritesButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)

        [worstOriginPrice, bestDiscoutPrice, toFavoritesButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            worstOriginPrice.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            worstOriginPrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            worstOriginPrice.heightAnchor.constraint(equalToConstant: 16),

            bestDiscoutPrice.topAnchor.constraint(equalTo: worstOriginPrice.bottomAnchor, constant: 4),
            bestDiscoutPrice.leadingAnchor.constraint(equalTo: worstOriginPrice.leadingAnchor),
            bestDiscoutPrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            bestDiscoutPrice.heightAnchor.constraint(equalToConstant: 28),
            bestDiscoutPrice.trailingAnchor.constraint(lessThanOrEqualTo: toFavoritesButton.leadingAnchor, constant: -16),

            toFavoritesButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            toFavoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toFavoritesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            toFavoritesButton.widthAnchor.constraint(equalToConstant: 165),
            toFavoritesButton.heightAnchor.constraint(equalToConstant: 51)
        ])

    }

    @objc func addToFavorite() {
        delegate?.addToFavorites()
    }

}
