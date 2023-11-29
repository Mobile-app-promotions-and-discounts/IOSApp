import UIKit
import SnapKit
import Combine

final class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    var cancellable: AnyCancellable?

    // PassthroughSubject для события нажатия кнопки
    private (set) var likeButtonTappedPublisher = PassthroughSubject<UUID, Never>()

    private var productID: UUID?

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
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()

    private lazy var nameAndDescriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    private lazy var lowPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var highPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [lowPriceLabel, highPriceLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
    }

    // MARK: - Public methods

    func configure(with model: ProductCellUIModel) {
        self.productID = model.id
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        likeButton.setImage(model.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)

        guard
            let lowerPrice = model.lowerPrice,
            let higherPrice = model.higherPrice else {
            return
        }

        lowPriceLabel.text = "от \(String(describing: lowerPrice.customFormatted())) ₽"
        highPriceLabel.text = "от \(String(describing: higherPrice.customFormatted())) ₽"
    }

    // MARK: - Private methods

    @objc
    private func likeButtonTapped() {
        // Переключение изображения кнопки "лайк"
        let isFavoriteNow = likeButton.currentImage == UIImage(systemName: "heart")
        likeButton.setImage(isFavoriteNow ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)

        if let productID = productID {
            likeButtonTappedPublisher.send(productID)
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .productCell
        contentView.layer.cornerRadius = 10

        [productImageView,
         nameAndDescriptionStackView,
         priceStackView,
         likeButton].forEach { contentView.addSubview($0) }

        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(128)
        }

        nameAndDescriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(productImageView)
        }

        priceStackView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
        }
    }
}
