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

        logoImageView.layer.cornerRadius = 14
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .lightGray

        goToStoreButton.setTitle("В магазин", for: .normal)
        goToStoreButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        goToStoreButton.backgroundColor = .lightGray
        goToStoreButton.layer.cornerRadius = 10

        storeNameLabel.font = .boldSystemFont(ofSize: 14)
        addressLabel.font = .systemFont(ofSize: 12)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        originalPriceLabel.font = .systemFont(ofSize: 14)
        discountLabel.font = .systemFont(ofSize: 14)

        originalPriceLabel.textColor = .gray
        originalPriceLabel.attributedText = NSAttributedString(
            string: "180р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )

        discountLabel.textColor = .red

        backgroundViewBoard.backgroundColor = .mainBG
        backgroundViewBoard.layer.cornerRadius = 10
        backgroundViewBoard.clipsToBounds = true
        backgroundViewBoard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundViewBoard)

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
            backgroundViewBoard.addSubview($0)
        }

        NSLayoutConstraint.activate([

            backgroundViewBoard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            backgroundViewBoard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundViewBoard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundViewBoard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            // Logo Image View
            logoImageView.leadingAnchor.constraint(equalTo: backgroundViewBoard.leadingAnchor, constant: paddingH),
            logoImageView.centerYAnchor.constraint(equalTo: backgroundViewBoard.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 28),
            logoImageView.heightAnchor.constraint(equalToConstant: 28),

            // Name Label
            storeNameLabel.topAnchor.constraint(equalTo: backgroundViewBoard.topAnchor, constant: paddingV),
            storeNameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 16),
            storeNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: goToStoreButton.leadingAnchor),

            addressLabel.topAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 2),
            addressLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: storeNameLabel.trailingAnchor),

            priceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: storeNameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: backgroundViewBoard.bottomAnchor, constant: -paddingV),

            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            originalPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),

            discountLabel.leadingAnchor.constraint(equalTo: originalPriceLabel.trailingAnchor, constant: 4),
            discountLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),

            goToStoreButton.trailingAnchor.constraint(equalTo: backgroundViewBoard.trailingAnchor, constant: -paddingH),
            goToStoreButton.centerYAnchor.constraint(equalTo: backgroundViewBoard.centerYAnchor),
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
