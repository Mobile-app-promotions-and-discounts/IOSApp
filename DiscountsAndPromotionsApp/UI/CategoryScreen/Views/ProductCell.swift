import UIKit
import SnapKit
import Combine
import Kingfisher

final class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    var cancellable: AnyCancellable?

    // PassthroughSubject для события нажатия кнопки
    private (set) var likeButtonTappedPublisher = PassthroughSubject<Int, Never>()

    private var productID: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI properties

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
        view.backgroundColor = UIColor.cherryWhite.withAlphaComponent(0.8)
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.layer.borderColor = UIColor.cherryBlack.withAlphaComponent(0.15).cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerSmall
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.numberOfLines = 2
        label.font = CherryFonts.headerSmall
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerMedium
        return label
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        cancellable?.cancel()
    }

    // MARK: - Public methods

    func configure(with model: ProductCellUIModel) {
        self.productID = model.id
        self.nameLabel.text = model.name
        if let imagePath = model.image,
           let imageURL = URL(string: imagePath) {
            productImageView.kf.setImage(with: imageURL, placeholder: UIImage.productImagePlaceholder)
        } else {
            productImageView.image = .productImagePlaceholder
        }
        self.likeButton.setImage(model.isFavorite ? UIImage.icHeartFill : UIImage.icHeart, for: .normal)
        self.priceLabel.text = model.formattedPriceRange
        self.discountLabel.text = model.formattedDiscount
        self.discountLabel.isHidden = model.formattedDiscount.isEmpty
        self.discountBGView.isHidden = model.formattedDiscount.isEmpty
    }

    // MARK: - Private methods

    @objc
    private func likeButtonTapped() {
        // Переключение изображения кнопки "лайк"
        let isFavoriteNow = likeButton.currentImage == UIImage.icHeart
        likeButton.setImage(isFavoriteNow ? UIImage.icHeartFill : UIImage.icHeart, for: .normal)

        if let productID {
            likeButtonTappedPublisher.send(productID)
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryLightBlue
        contentView.layer.cornerRadius = 10

        [productImageView,
         discountBGView,
         discountLabel,
         nameLabel,
         priceLabel,
         likeButton].forEach { contentView.addSubview($0) }

        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(128)
        }

        discountBGView.snp.makeConstraints { make in
            make.top.leading.equalTo(productImageView).inset(6)
            make.height.equalTo(24)
            make.width.equalTo(64)
        }

        discountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(discountBGView)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(productImageView)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
            make.top.equalTo(nameLabel.snp.bottom).inset(-4)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(likeButton.snp.leading).inset(-16)
        }
    }
}
