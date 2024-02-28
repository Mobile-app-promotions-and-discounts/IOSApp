import UIKit
import SnapKit
import Combine
import Kingfisher

final class ProductCell: UICollectionViewCell {
    enum Mode {
        case regular
        case favorites
    }

    static let reuseIdentifier = "ProductCell"

    var cancellable: AnyCancellable?

    // PassthroughSubject для события нажатия кнопки
    private (set) var likeButtonTappedPublisher = PassthroughSubject<Int, Never>()
    private (set) var isProcessingFavorite = false {
        didSet {
            isProcessingFavorite ? likeButton.startLoadingAnimation() : likeButton.stopLoadingAnimation()
        }
    }
    private (set) var isInactive = false {
        didSet {
            inactiveOverlay.alpha = isInactive ? 0.8 : 0.0
            priceLabel.isHidden = isInactive
            inactiveLabel.isHidden = !isInactive
        }
    }

    private var productID: Int?
    private var mode: Mode = .regular

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
        imageView.backgroundColor = .cherryAlwaysWhite
        imageView.layer.cornerRadius = CornerRadius.small.cgFloat()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var discountBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cherryYellow2
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.layer.borderColor = UIColor.cherryBlack.withAlphaComponent(0.15).cgColor
        view.layer.borderWidth = 1
        return view
    }()

    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryAlwaysBlack
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

    private lazy var inactiveOverlay = {
        let view = UIView()
        view.backgroundColor = .cherryLightBlue
        view.alpha = 0
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return view
    }()

    private lazy var inactiveLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = CherryFonts.headerSmall
        label.textColor = UIColor.cherryMainAccent
        label.textAlignment = .left
        label.text = NSLocalizedString("Unfavorited", tableName: "FavoritesFlow", comment: "")
        label.isHidden = true
        label.adjustsFontSizeToFitWidth = true
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
        isInactive = false
    }

    // MARK: - Public methods

    func makeInactive() {
        isInactive = true
    }

    func makeActive() {
        isInactive = false
    }

    func setMode(to mode: Mode) {
        self.mode = mode
    }

    func updateFavoriteStatus(isFavorite: Bool) {
        self.likeButton.setImage(isFavorite ? UIImage.icHeartFill : UIImage.icHeart, for: .normal)
        if mode == .favorites {
            isInactive = !isFavorite
        }
        isProcessingFavorite = false
    }

    func configure(with model: ProductCellUIModel) {
        self.productID = model.id
        self.nameLabel.text = model.name
        if let imagePath = model.image,
           let imageURL = URL(string: imagePath) {
            productImageView.kf.setImage(with: imageURL,
                                         placeholder: UIImage.productImagePlaceholder,
                                         options: [
                                               .transition(ImageTransition.fade(0.3))])
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
        isProcessingFavorite = true

        if let productID {
            likeButtonTappedPublisher.send(productID)
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryLightBlueCard
        contentView.layer.cornerRadius = CornerRadius.regular.cgFloat()

        [productImageView,
         discountBGView,
         discountLabel,
         nameLabel,
         priceLabel,
         inactiveOverlay,
         inactiveLabel,
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

        inactiveOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(24)
            make.top.equalTo(nameLabel.snp.bottom).inset(-4)
        }

        inactiveLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.height.centerY.equalTo(likeButton)
            make.trailing.equalTo(likeButton.snp.leading).offset(-4)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.trailing.equalTo(likeButton.snp.leading).inset(-16)
        }
    }
}
