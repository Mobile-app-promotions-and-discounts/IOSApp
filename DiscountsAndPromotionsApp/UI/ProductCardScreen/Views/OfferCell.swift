//
//  OfferCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 27.11.2023.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    private let backgroundViewBoard = UIView()
    private let logoImageView = UIImageView()
    private let storeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let goToStoreButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let paddingH: CGFloat = 12
        let paddingV: CGFloat = 8

        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .lightGray

        goToStoreButton.setTitle("В магазин", for: .normal)
        goToStoreButton.backgroundColor = .lightGray
        goToStoreButton.layer.cornerRadius = 10

        storeNameLabel.font = .boldSystemFont(ofSize: 16)
        addressLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        originalPriceLabel.font = .systemFont(ofSize: 14)
        discountLabel.font = .systemFont(ofSize: 14)

        originalPriceLabel.textColor = .gray
        originalPriceLabel.attributedText = NSAttributedString(
            string: "180р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )

        discountLabel.textColor = .red

        let views = [
            logoImageView,
            storeNameLabel,
            addressLabel,
            priceLabel,
            originalPriceLabel,
            discountLabel,
            goToStoreButton]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Logo Image View
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddingH),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 28),
            logoImageView.heightAnchor.constraint(equalToConstant: 28),

            // Name Label
            storeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingV),
            storeNameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 16),
            storeNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: goToStoreButton.leadingAnchor),

            addressLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: storeNameLabel.trailingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingV),

            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            originalPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),

            discountLabel.leadingAnchor.constraint(equalTo: originalPriceLabel.trailingAnchor, constant: 4),
            discountLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),

            goToStoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -paddingH),
            goToStoreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            goToStoreButton.widthAnchor.constraint(equalToConstant: 84),
            goToStoreButton.heightAnchor.constraint(equalToConstant: 30)
        ])

    }

    func configure(with offer: Offer) {
        storeNameLabel.text = offer.store.name
        addressLabel.text = offer.store.location.street
        priceLabel.text = "\(offer.price)"
        discountLabel.text = "\(String(describing: offer.discount?.discountRate))"
    }
}
