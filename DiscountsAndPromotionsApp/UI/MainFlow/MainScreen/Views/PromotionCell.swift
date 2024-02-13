import UIKit
import SnapKit
import Kingfisher

final class PromotionCell: UICollectionViewCell {
    static let reuseIdentifier = "PromotionCell"

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cherryWhite
        imageView.layer.cornerRadius = CornerRadius.small.cgFloat()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var discountBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cherryYellow2
        view.layer.cornerRadius = CornerRadius.small.cgFloat()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.cherryForeground.withAlphaComponent(0.15).cgColor
        return view
    }()

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.textSmall
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerSmall
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: PromotionUIModel) {
        // Заполняем содержимое акции
        if let imagePath = model.productImage {
            productImageView.image = UIImage(named: imagePath)
        }

        discountLabel.text = model.discount
        priceLabel.text = model.price

        if let image = model.productImage {
            productImageView.kf.setImage(with: URL(string: image),
                                         placeholder: UIImage.productImagePlaceholder,
                                         options: [
                                               .transition(ImageTransition.fade(0.3))])
        } else {
            productImageView.image = .productImagePlaceholder
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.productImageView.alpha = 1
        })

        discountLabel.isHidden = model.discount.isEmpty
        discountBGView.isHidden = model.discount.isEmpty
    }

    private func setupViews() {
        contentView.layer.cornerRadius = CornerRadius.large.cgFloat()
        contentView.clipsToBounds = true
        contentView.backgroundColor = .cherryLightBlue

        [priceLabel, productImageView, discountBGView, discountLabel].forEach { contentView.addSubview($0) }

        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }

        productImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalTo(priceLabel.snp.top).inset(-4)
        }
        productImageView.alpha = 0

        discountBGView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.top).inset(4)
            make.leading.equalTo(productImageView).inset(6)
            make.height.equalTo(18)
            make.width.equalTo(60)
        }
        discountBGView.isHidden = true

        discountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(discountBGView.snp.centerX)
            make.centerY.equalTo(discountBGView.snp.centerY)
        }
        discountLabel.isHidden = true
    }
}
