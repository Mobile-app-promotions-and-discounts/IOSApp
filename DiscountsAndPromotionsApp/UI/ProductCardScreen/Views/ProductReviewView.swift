//
//  ProductReviewView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit
import SnapKit

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
        configureView()
        setupTitleLabel()
        setupStarsStackView()
        setupReviewTextView()
        setupTextView()
        setupSubmitButton()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        backgroundColor = .mainBG // Убедитесь, что цвет определен в вашем расширении UIColor
        layer.cornerRadius = 12
    }

    private func setupTitleLabel() {
        titleLabel.text = "Как Вам этот товар?"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(titleLabel)
    }

    private func setupStarsStackView() {
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        for _ in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .black
            starsStackView.addArrangedSubview(starButton)
        }
        addSubview(starsStackView)
    }

    private func setupReviewTextView() {
        reviewTextView.font = .systemFont(ofSize: 16)
        reviewTextView.textColor = .lightGray
        reviewTextView.text = "Ваш отзыв"
        reviewTextView.layer.borderColor = UIColor.gray.cgColor
        reviewTextView.layer.borderWidth = 1.0
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        reviewTextView.isScrollEnabled = false
        reviewTextView.delegate = self
        addSubview(reviewTextView)
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

    private func setupSubmitButton() {
        submitButton.setImage(UIImage(named: "submitReview"), for: .normal)
        submitButton.tintColor = .black
        addSubview(submitButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(19)
        }

        starsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.width.equalTo(152)
        }

        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(starsStackView.snp.bottom).offset(20)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.equalTo(self.snp.trailing).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
            make.height.greaterThanOrEqualTo(79)
        }

        submitButton.snp.makeConstraints { make in
            make.trailing.equalTo(reviewTextView.snp.trailing).offset(-8)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.height.width.equalTo(24)
        }
    }

    private func setupActions() {
        for (index, button) in starsStackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                button.tag = index + 1 // Теги начинаются с 1
                button.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
            }
        }
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func starTapped(_ sender: UIButton) {
        let selectedRating = sender.tag
        rating = selectedRating

        for (index, button) in starsStackView.arrangedSubviews.enumerated() {
            if let button = button as? UIButton {
                button.setImage(UIImage(systemName: index < selectedRating ? "star.fill" : "star"), for: .normal)
                button.tintColor = index < selectedRating ? .systemYellow : .gray
            }
        }
    }

    @objc private func submitButtonTapped() {
        let reviewText = reviewTextView.text ?? ""
        delegate?.didTapSubmitButton(rating: rating, review: reviewText)
        print("Отправка отзыва")
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
        previousText = textView.text // Сохраняем текущий текст
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ваш отзыв"
            textView.textColor = UIColor.lightGray
        }
    }
}
