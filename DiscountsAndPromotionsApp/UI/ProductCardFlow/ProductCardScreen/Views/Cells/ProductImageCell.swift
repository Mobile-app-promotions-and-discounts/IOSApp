import UIKit
import Kingfisher
import SnapKit

final class ProductImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductImageCell"

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.tomatoMock
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        productImageView.image = nil
    }

    func configure(with model: ProductUIModel) {
        if let imageString = model.image,
           let imageURL = URL(string: imageString) {
            productImageView.kf.setImage(with: imageURL,
                                       options: [
                                        .transition(ImageTransition.fade(0.3))])
        } else {
            productImageView.image = UIImage.productImagePlaceholder
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryWhite
        contentView.addSubview(productImageView)

        productImageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}
