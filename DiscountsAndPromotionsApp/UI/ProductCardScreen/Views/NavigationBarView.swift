//
//  NavigationBarView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 28.11.2023.
//

import UIKit

class CustomNavigationBarView: UIView {

    let backButton = UIButton()
    let uploadButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Настройка внешнего вида кнопки возврата
        backButton.setImage(UIImage(named: "backImage"), for: .normal) // Замените "backIcon" на имя вашего изображения
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Настройка кнопки загрузки
        uploadButton.setImage(UIImage(named: "sendImage"), for: .normal) // Замените "uploadIcon" на имя вашего изображения
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)

        [backButton, uploadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        // Установите здесь свои ограничения
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func backButtonTapped() {
        // Обработка нажатия на кнопку возврата
    }

    @objc func uploadButtonTapped() {
        // Обработка нажатия на кнопку загрузки
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44), // Примерный размер
            backButton.heightAnchor.constraint(equalToConstant: 44),

            uploadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uploadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            uploadButton.widthAnchor.constraint(equalToConstant: 44), // Примерный размер
            uploadButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
