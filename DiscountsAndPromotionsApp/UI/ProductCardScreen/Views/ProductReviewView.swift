//
//  ProductReviewView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit

protocol ProductReviewViewDelegate: AnyObject {
    func didTapSubmitButton(rating: Int, review: String)
}

class ProductReviewView: UIView {

    weak var delegate: ProductReviewViewDelegate?

    private let titleLabel = UILabel()
    private let starsStackView = UIStackView()
    private let reviewTextField = UITextField()
    private let submitButton = UIButton()

    private var rating: Int = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
            // Общий вид компонента
            backgroundColor = .gray
            layer.cornerRadius = 12

            // Настройка заголовка
            titleLabel.text = "Как Вам этот товар?"
            titleLabel.font = .boldSystemFont(ofSize: 18)

            // Настройка стека звезд
            starsStackView.axis = .horizontal
            starsStackView.distribution = .fillEqually
            for _ in 0..<5 {
                let starButton = UIButton()
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                starButton.tintColor = .gray
                starsStackView.addArrangedSubview(starButton)
            }

            // Настройка текстового поля для отзыва
            reviewTextField.placeholder = "Ваш отзыв"
            reviewTextField.borderStyle = .roundedRect

            // Настройка кнопки отправки
            submitButton.setImage(UIImage(systemName: "submitReview"), for: .normal)
            submitButton.tintColor = .black

            // Добавляем элементы в компонент
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(starsStackView)
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(reviewTextField)
        reviewTextField.translatesAutoresizingMaskIntoConstraints = false
            addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 19),

            starsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            starsStackView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),

            reviewTextField.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 20),

            reviewTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            reviewTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            reviewTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            submitButton.trailingAnchor.constraint(equalTo: reviewTextField.trailingAnchor, constant: -8),
            submitButton.bottomAnchor.constraint(equalTo: reviewTextField.bottomAnchor, constant: -8),
            submitButton.heightAnchor.constraint(equalToConstant: 24),
            submitButton.widthAnchor.constraint(equalToConstant: 24)

        ])
    }

    private func setupActions() {
        // Настройка событий нажатия на звезды
        for (index, button) in starsStackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                button.tag = index + 1 // Теги начинаются с 1
                button.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
            }
        }
        // Настройка события нажатия на кнопку отправки
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func starTapped(_ sender: UIButton) {
        let selectedRating = sender.tag
        rating = selectedRating

        // Обновляем вид звезд
        for (index, button) in starsStackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                button.setImage(UIImage(systemName: index < selectedRating ? "star.fill" : "star"), for: .normal)
                button.tintColor = index < selectedRating ? .systemYellow : .gray
            }
        }
    }

    @objc private func submitButtonTapped() {
        let reviewText = reviewTextField.text ?? ""
        delegate?.didTapSubmitButton(rating: rating, review: reviewText)
    }
}
