import UIKit
import SnapKit

final class PromotionCell: UICollectionViewCell {
    static let reuseIdentifier = "PromotionCell"

    private lazy var storeLogoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var promoTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.numberOfLines = 0
        label.font = CherryFonts.headerSmall
        return label
    }()

    private lazy var promotionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: PromotionUIModel) {
        // Удаляем предыдущие градиентные слои, если они есть
        contentView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        // Установка логотипа магазина и текста акции
        storeLogoImageView.image = model.storeLogo
        promoTextLabel.text = model.promoText
        promotionImageView.image = model.promotionImage

        // Настройка градиента заднего фона
        let gradientLayer = model.gradientLayer
        gradientLayer.frame = contentView.bounds
        gradientLayer.needsDisplayOnBoundsChange = true

        // Добавление градиента к contentView
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupViews() {
        contentView.layer.cornerRadius = CornerRadius.large.cgFloat()
        contentView.clipsToBounds = true

        [storeLogoImageView, promoTextLabel, promotionImageView].forEach { contentView.addSubview($0) }

        storeLogoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.top.equalToSuperview().inset(8)
        }

        promotionImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.size.equalTo(CGSize(width: 51, height: 39))
        }

        promoTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(storeLogoImageView.snp.bottom).offset(4)
        }
    }
}
