//
//  ImageGalleryView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit

class ImageGalleryView: UIView {

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    override init(frame: CGRect) {
            super.init(frame: frame)
            setupLayout()
        }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    func setupLayout() {
        addSubview(imageView)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16), // Добавлено ограничение
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 288),
            pageControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16) // Добавлено ограничение
        ])
    }
    
        func configure(with image: UIImage) {
            imageView.image = image
        }
}
