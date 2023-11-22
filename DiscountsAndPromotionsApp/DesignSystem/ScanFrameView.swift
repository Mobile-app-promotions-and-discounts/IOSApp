//
//  ScanFrameView.swift
//  DiscountsAndPromotionsApp
//
//  Created by Aleksey Yakushev on 21.11.2023.
//

import UIKit

final class ScanFrameView: UIView {
    private let cornerFrameTop: UIImage = UIImage(named: "ScannerCorner") ?? UIImage()
    private lazy var cornerFrameBottom: UIImage = cornerFrameTop.withVerticalyFlippedOrientation()

    private lazy var topL = UIImageView(image: cornerFrameTop)
    private lazy var topR = UIImageView(image: cornerFrameTop.withHorizontallyFlippedOrientation())
    private lazy var bottomL = UIImageView(image: cornerFrameBottom)
    private lazy var bottomR = UIImageView(image: cornerFrameBottom.withHorizontallyFlippedOrientation())

    override func layoutSubviews() {
        for cornerView in [topL, bottomL, topR, bottomR] {
            addSubview(cornerView)
        }
        topL.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        topR.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        bottomL.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        bottomR.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
