//
//  ImageGalleryCell.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 22.11.2023.
//

import UIKit

class ImageGalleryCell: UICollectionViewCell {
    
    static let identifier = "ImageGalleryCell"
    
    private var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.pageIndicatorTintColor = .gray
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
        [imageView, pageControl].forEach {
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 288),
        
            pageControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // Функция для конфигурации ячейки с данными
    func configure(with images: [UIImage]) {
        pageControl.numberOfPages = images.count
        pageControl.isHidden = images.count <= 1
        
        imageView.image = images.first ?? UIImage(named: "placeholder")
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
        imageView.image = nil
        pageControl.currentPage = 0
    }
}
