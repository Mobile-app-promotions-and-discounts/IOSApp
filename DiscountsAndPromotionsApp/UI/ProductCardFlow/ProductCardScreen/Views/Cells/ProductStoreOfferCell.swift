import UIKit
import SnapKit
import Combine

final class ProductStoreOfferCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductStoreOfferCell"

    var cancellables = Set<AnyCancellable>()

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .cherryLightBlueCard
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .okeiLogo
        return imageView
    }()

    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        label.text = "Пятерочка"
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerSmall
        label.textColor = .cherryBlack
        label.text = "ул. Ленина, д. 4, строение 7"
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
        label.text = "170 ₽"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryAlwaysBlack
        label.text = "–99%"
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
            string: "200 ₽",
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
        cancellables.removeAll()
    }

    @objc
    private func goToStoreCard() {
        print("goToStoreCard")
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
