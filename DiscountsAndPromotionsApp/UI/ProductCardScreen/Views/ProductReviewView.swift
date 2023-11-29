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
    private let reviewTextView = UITextView()
    private let submitButton = UIButton()

    private var rating: Int = 1
    private var previousText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
        setupTextView()
        reviewTextView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        // Общий вид компонента
        backgroundColor = .mainBG
        layer.cornerRadius = 12

        // Настройка заголовка
        titleLabel.text = "Как Вам этот товар?"
        titleLabel.font = .boldSystemFont(ofSize: 18)

        // Настройка стека звезд
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        for _ in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            starButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            starButton.tintColor = .black
            starsStackView.addArrangedSubview(starButton)
        }

        reviewTextView.font = .systemFont(ofSize: 16)
        reviewTextView.textColor = .lightGray
        reviewTextView.text = "Ваш отзыв"
        reviewTextView.layer.borderColor = UIColor.gray.cgColor
        reviewTextView.layer.borderWidth = 1.0
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) // Отступы текста
        reviewTextView.isScrollEnabled = false
        reviewTextView.delegate = self
        // Настройка кнопки отправки
        submitButton.setImage(UIImage(named: "submitReview"), for: .normal)
        submitButton.tintColor = .black

        // Добавляем элементы в компонент
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starsStackView)
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reviewTextView)
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 19),

            starsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            starsStackView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            starsStackView.widthAnchor.constraint(equalToConstant: 152),

            reviewTextView.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 20),

            reviewTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            reviewTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            reviewTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            reviewTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 79),

            submitButton.trailingAnchor.constraint(equalTo: reviewTextView.trailingAnchor, constant: -8),
            submitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
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

    private func setupTextView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancelButton = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped))

        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        reviewTextView.inputAccessoryView = toolbar
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
        print("Отправка отзыва")
        let reviewText = reviewTextView.text ?? ""
        delegate?.didTapSubmitButton(rating: rating, review: reviewText)
    }

    @objc private func cancelButtonTapped() {
        // Действие для кнопки "Отмена"
        reviewTextView.text = previousText
        reviewTextView.resignFirstResponder()
    }

    @objc private func doneButtonTapped() {
        // Действие для кнопки "Готово"
//        let reviewText = reviewTextView.text ?? ""
//        delegate?.didTapSubmitButton(rating: rating, review: reviewText)
        reviewTextView.resignFirstResponder()
    }

}

extension ProductReviewView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: Notification.Name("TextViewDidBeginEditing"), object: self)
        previousText = textView.text // Сохраняем текущий текст
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: Notification.Name("TextViewDidEndEditing"), object: self)
        if textView.text.isEmpty {
            textView.text = "Ваш отзыв"
            textView.textColor = UIColor.lightGray
        }
    }
}
