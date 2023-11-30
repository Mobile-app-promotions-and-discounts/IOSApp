//
//  PriceInfoView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//
import UIKit
import SnapKit

protocol PriceInfoViewDelegate: AnyObject {
    func addToFavorites()
}

class PriceInfoView: UIView {

    weak var delegate: PriceInfoViewDelegate?
    private let toFavoritesButton = UIButton()
    private let worstOriginPrice = UILabel()
    private let bestDiscountPrice = UILabel()

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

        bestDiscountPrice.text = "от \(discountPrice)р"
    }

    private func setupLayout() {
        setupWorstOriginPriceLabel()
        setupBestDiscountPriceLabel()
        setupToFavoritesButton()
        setupConstraints()
    }

    private func setupWorstOriginPriceLabel() {
        worstOriginPrice.textColor = .gray
        worstOriginPrice.font = .systemFont(ofSize: 14)
        worstOriginPrice.attributedText = NSAttributedString(
            string: "300р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        addSubview(worstOriginPrice)
    }

    private func setupBestDiscountPriceLabel() {
        bestDiscountPrice.textColor = .black
        bestDiscountPrice.font = .boldSystemFont(ofSize: 24)
        bestDiscountPrice.text = "от 150р"
        addSubview(bestDiscountPrice)
    }

    private func setupToFavoritesButton() {
        toFavoritesButton.setTitle("В Избранное", for: .normal)
        toFavoritesButton.backgroundColor = .lightGray
        toFavoritesButton.layer.cornerRadius = 10
        toFavoritesButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        toFavoritesButton.tintColor = .black
        toFavoritesButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        addSubview(toFavoritesButton)
    }

    private func setupConstraints() {
        worstOriginPrice.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }

        bestDiscountPrice.snp.makeConstraints { make in
            make.top.equalTo(worstOriginPrice.snp.bottom).offset(4)
            make.leading.equalTo(worstOriginPrice.snp.leading)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(28)
            make.trailing.lessThanOrEqualTo(toFavoritesButton.snp.leading).offset(-16)
        }

        toFavoritesButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-24)
            make.width.equalTo(165)
            make.height.equalTo(51)
        }
    }

    @objc func addToFavorite() {
        delegate?.addToFavorites()
    }
}
