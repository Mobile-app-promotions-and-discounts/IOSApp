import UIKit
import SnapKit
import Combine
import Kingfisher

final class ProductStoreOfferCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductStoreOfferCell"

    private (set) var openStoreSiteButtonTappedPublisher = PassthroughSubject<String, Never>()

    var cancellable: AnyCancellable?

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .cherryLightBlueCard
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        return imageView
    }()

    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerSmall
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var storeInfoStackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(storeNameLabel)
        stackView.addArrangedSubview(addressLabel)
        return stackView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryAlwaysBlack
        label.font = CherryFonts.textSmall
        return label
    }()

    private lazy var discountBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cherryYellow2
        view.layer.cornerRadius = CornerRadius.small.cgFloat()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.cherryForeground.withAlphaComponent(0.15).cgColor
        return view
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlueGray
        label.font = CherryFonts.textMedium
        // Создаем атрибутированную строку с атрибутом перечеркивания
        let attributeString = NSMutableAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        label.attributedText = attributeString
        return label
    }()

    private lazy var priceStackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(discountBGView)
        stackView.addArrangedSubview(originalPriceLabel)
        return stackView
    }()

    private lazy var storeOfferStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.addArrangedSubview(storeInfoStackView)
        stackView.addArrangedSubview(priceStackView)
        return stackView
    }()

    private var storeURL: String?

    private lazy var goToStoreButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()

        let title = NSLocalizedString("ToShopSite", tableName: "ProductFlow", comment: "")

        var attributedTitle = AttributedString(title)
        attributedTitle.font = CherryFonts.headerSmall
        config.attributedTitle = attributedTitle

        config.image = .icStoreArrow
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = UIColor.cherryBlack

        button.configuration = config
        button.backgroundColor = .cherryWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.cherryGrayBlue.cgColor
        button.layer.cornerRadius = CornerRadius.regular.cgFloat()

        button.addTarget(self, action: #selector(goToStoreCard), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        cancellable = nil
    }

    func configure(with model: ProductStoreOfferUIModel) {
        print(model.storeAdress)
        if let logoURL = URL(string: model.storeLogo ?? "") {
            logoImageView.kf.setImage(with: logoURL)
        }
        self.storeNameLabel.text = model.storeName
        self.addressLabel.text = model.storeAdress
        self.storeURL = model.storeURLadress
        self.priceLabel.text = String(model.finalPrice)
        self.discountLabel.text = model.discounValue
        self.originalPriceLabel.text = String(model.oldPrice)
    }

    @objc
    private func goToStoreCard() {
        guard let url = storeURL else {
            ErrorHandler.handle(error: .customError("Ошибка присвоения адреса сайта"))
            return
        }
        openStoreSiteButtonTappedPublisher.send(url)
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryWhite
        contentView.addSubview(bgView)
        discountBGView.addSubview(discountLabel)
        [logoImageView, storeOfferStackView, goToStoreButton].forEach { bgView.addSubview($0) }

        bgView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        discountBGView.snp.makeConstraints { make in
            make.width.equalTo(41)
        }

        discountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(discountBGView)
        }

        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }

        storeOfferStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(logoImageView.snp.trailing).offset(8)
            make.trailing.equalTo(goToStoreButton.snp.leading).offset(-8)
        }

        goToStoreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(109)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}
