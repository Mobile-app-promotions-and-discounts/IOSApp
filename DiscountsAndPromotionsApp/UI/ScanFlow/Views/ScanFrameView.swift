//
import UIKit

final class ScanFrameView: UIView {
    private let cornerFrameTop: UIImage = UIImage.scannerCorner
    private lazy var cornerFrameBottom: UIImage = cornerFrameTop.withVerticallyFlippedOrientation()

    private lazy var topL = UIImageView(image: cornerFrameTop)
    private lazy var topR = UIImageView(image: cornerFrameTop.withHorizontallyFlippedOrientation())
    private lazy var bottomL = UIImageView(image: cornerFrameBottom)
    private lazy var bottomR = UIImageView(image: cornerFrameBottom.withHorizontallyFlippedOrientation())

    override func layoutSubviews() {
        for cornerView in [topL, bottomL, topR, bottomR] {
            addSubview(cornerView)
        }
        topL.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        topR.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        bottomL.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
        }
        bottomR.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
        }
    }
}
