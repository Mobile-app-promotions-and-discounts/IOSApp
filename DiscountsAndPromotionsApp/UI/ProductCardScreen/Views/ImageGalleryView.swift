//
//  ImageGalleryView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit

class ImageGalleryView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private var images: [UIImage] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        scrollView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addSubview(scrollView)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            //            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16), // Добавлено ограничение
            //            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            //            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            //            imageView.heightAnchor.constraint(equalToConstant: 288),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16) // Добавлено ограничение
        ])
    }

    func configure(with images: [UIImage]) {
        self.images = images
        scrollView.delegate = self
//        setupImagesInScrollView(images)
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
    }

    private func setupImagesInScrollView(_ images: [UIImage]) {
//        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(images.count), height: bounds.height)
//
//        scrollView.subviews.forEach {
//            $0.removeFromSuperview()
//        }

//        for (index, image) in images.enumerated() {
//            let imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.layer.cornerRadius = 12
//            imageView.frame = CGRect(x: bounds.width * CGFloat(index), y: 0, width: bounds.width, height: bounds.height)
//            scrollView.addSubview(imageView)
//        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = bounds
        pageControl.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20)

        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.frame = CGRect(x: bounds.width * CGFloat(index), y: 0, width: bounds.width, height: bounds.height)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(images.count), height: bounds.height)
    }
}

extension ImageGalleryView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
