//
//  ImageGalleryView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Денис on 23.11.2023.
//

import UIKit
import SnapKit

class ImageGalleryView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
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

        scrollView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configure(with images: [UIImage]) {
        self.images = images
        scrollView.delegate = self
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
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
            imageView.frame = CGRect(
                x: bounds.width * CGFloat(index) + 16,
                y: 0,
                width: bounds.width - 32,
                height: bounds.height)
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
