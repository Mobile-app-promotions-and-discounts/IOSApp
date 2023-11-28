//
//  RatingView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

protocol RatingViewDelegate: AnyObject {
    func reviewsButtonTapped()
}

import UIKit
class RatingView: UIView {

    weak var delegate: RatingViewDelegate?

    private let starsStackView =  UIStackView()
    private let ratingLabel = UILabel()
    private let numberOfReviewsLabel = UILabel()

    private lazy var reviewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.addTarget(self,
                         action: #selector(reviewsButtonTapped),
                         for: .touchUpInside)
        button.tintColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        button.backgroundColor = .mainBG
        button.isUserInteractionEnabled = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureStars()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rating: Double, numberOfReviews: Int) {
        for (index, star) in starsStackView.arrangedSubviews.enumerated() {
            star.isHidden = index >= Int(rating)
        }

        ratingLabel.text = "\(rating)"

        numberOfReviewsLabel.text = "\(numberOfReviews) отзывов"

//        reviewsButton.setImage(UIImage(systemName: "checron.right"), for: .normal)
    }

    private func setupLayout() {
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        addSubview(starsStackView)
        addSubview(ratingLabel)
        addSubview(numberOfReviewsLabel)
        addSubview(reviewsButton)

        [starsStackView, ratingLabel, numberOfReviewsLabel, reviewsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: topAnchor),
            starsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            starsStackView.heightAnchor.constraint(equalToConstant: 16), // Примерная высота

            ratingLabel.centerYAnchor.constraint(equalTo: starsStackView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starsStackView.trailingAnchor, constant: 8),

            numberOfReviewsLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 4),
            numberOfReviewsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            numberOfReviewsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            reviewsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            reviewsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            reviewsButton.widthAnchor.constraint(equalToConstant: 28), // Примерная ширина
            reviewsButton.heightAnchor.constraint(equalTo: reviewsButton.widthAnchor) // Круглая кнопка
        ])
    }

    private func configureStars() {
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(named: "star"))
            star.contentMode = .scaleAspectFit
            star.isHidden = true
            starsStackView.addArrangedSubview(star)
        }
    }
    // TODO: - КНОПКА НЕ РАБОТАЕТ! Не нажимается на главном экране
    @objc private func reviewsButtonTapped() {
        print("Нажатие")
        delegate?.reviewsButtonTapped()
    }

}
