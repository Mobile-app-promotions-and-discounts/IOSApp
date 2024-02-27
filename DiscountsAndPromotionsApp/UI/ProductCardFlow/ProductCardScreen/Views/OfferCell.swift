import Combine
import Kingfisher
import SnapKit
import UIKit

class OfferTableViewCell: UITableViewCell {
    let websitePublisher = CurrentValueSubject<String, Never>("")
    var cancellables = Set<AnyCancellable>()

    private let backgroundViewBoard = UIView()
    private let logoImageView = UIImageView()
    private let storeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
    private let discountView = UIView()
    private let discountLabel = UILabel()
    private let goToStoreButton = UIButton(configuration: .plain(), primaryAction: nil)
    private var storeURL: String = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupBackgroundView()
        configureLogoImageView()
        configureGoToStoreButton()
        configureLabels()
        setupConstraints()
        configureDiscountView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        cancellables.removeAll()
    }

    // MARK: Настройка

    func configure(with offer: OfferUIModel) {
        storeURL = offer.store.chainStore?.website ?? ""
        storeNameLabel.text = offer.store.name
        addressLabel.text = offer.store.location.street
        priceLabel.text = "\(Int(offer.discountPrice)) ₽"
        if let logoURL = URL(string: offer.store.chainStore?.logo ?? "") {
            logoImageView.kf.setImage(with: logoURL)
        }
        if offer.discountPrice < offer.initialPrice {
            originalPriceLabel.isHidden = false
            discountLabel.isHidden = offer.discount == nil
            discountView.isHidden = offer.discount == nil

            originalPriceLabel.text = "\(Int(offer.initialPrice)) ₽"
            discountLabel.text = offer.discount?.formattedDiscountString() ?? ""
        } else {
            originalPriceLabel.isHidden = true
            discountLabel.isHidden = true
            discountView.isHidden = true

            originalPriceLabel.text = ""
            discountLabel.text = ""
        }
    }

    private func setupBackgroundView() {
        contentView.addSubview(backgroundViewBoard)
        contentView.backgroundColor = .cherryWhite
        backgroundViewBoard.backgroundColor = .cherryLightBlue
        backgroundViewBoard.layer.cornerRadius = CornerRadius.regular.cgFloat()
        backgroundViewBoard.clipsToBounds = true
    }

    private func addSubviews() {
        [logoImageView,
         storeNameLabel,
         addressLabel,
         priceLabel,
         originalPriceLabel,
         discountView,
         goToStoreButton].forEach {
            backgroundViewBoard.addSubview($0)
        }
        discountView.addSubview(discountLabel)
    }

    private func configureLogoImageView() {
        logoImageView.layer.cornerRadius = 14
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .cherryWhite
    }

    private func configureDiscountView() {
        discountView.layer.cornerRadius = 11
        discountView.clipsToBounds = true
        discountView.layer.borderWidth = 1
        discountView.layer.borderColor = UIColor.cherryStroke.cgColor
        discountView.backgroundColor = .cherryYellow2
    }

    private func configureGoToStoreButton() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "ic_storeArrow")
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = UIColor.cherryBlack
        config.baseBackgroundColor = .cherryWhite
        goToStoreButton.setTitleColor(.cherryBlack, for: .normal)

        var attributedTitle = AttributedString("На сайт магазина")
        attributedTitle.font = CherryFonts.headerSmall
        config.attributedTitle = attributedTitle

        goToStoreButton.contentHorizontalAlignment = .center

        goToStoreButton.configuration = config
        goToStoreButton.layer.borderWidth = 1
        goToStoreButton.layer.borderColor = UIColor.cherryGrayBlue.cgColor
        goToStoreButton.layer.cornerRadius = CornerRadius.regular.cgFloat()
        goToStoreButton.backgroundColor = .cherryWhite

        goToStoreButton.addAction(UIAction { [weak self] _ in
                self?.goToStoreCard()
            }, for: .touchUpInside)

    }

    private func configureLabels() {
        storeNameLabel.font = CherryFonts.headerMedium
        storeNameLabel.textColor = .cherryBlack
        addressLabel.font = CherryFonts.headerSmall
        addressLabel.textColor = .cherryBlack
        addressLabel.textAlignment = .left
        addressLabel.setContentHuggingPriority(UILayoutPriority(0), for: .horizontal)
        priceLabel.font = CherryFonts.textMedium
        priceLabel.textColor = .cherryBlack
        originalPriceLabel.font = CherryFonts.textMedium
        originalPriceLabel.textColor = .cherryBlueGray
        originalPriceLabel.attributedText = NSAttributedString(
            string: "...",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        discountLabel.font = CherryFonts.textSmall
        discountLabel.textColor = .black
    }

    private func setupConstraints() {
        let paddingH: CGFloat = 12
        let paddingV: CGFloat = 8

        backgroundViewBoard.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(2)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.height.equalTo(56)
        }

        logoImageView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundViewBoard.snp.leading).offset(paddingH)
            make.centerY.equalTo(backgroundViewBoard.snp.centerY)
            make.width.height.equalTo(28)
        }

        storeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewBoard.snp.top).offset(paddingV)
            make.leading.equalTo(logoImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(goToStoreButton.snp.leading)
            make.height.equalTo(19)
        }

        addressLabel.snp.makeConstraints { make in
            make.bottom.equalTo(storeNameLabel)
            make.leading.equalTo(storeNameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(goToStoreButton.snp.leading).offset(-4)
            make.height.equalTo(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(storeNameLabel)
        }

        discountView.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(8)
            make.centerY.equalTo(priceLabel)
            make.height.equalTo(22)
            make.width.equalTo(46)
        }

        discountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(discountView)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(discountView.snp.trailing).offset(8)
            make.centerY.equalTo(priceLabel)
        }

        goToStoreButton.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundViewBoard.snp.trailing).offset(-paddingH)
            make.centerY.equalTo(backgroundViewBoard.snp.centerY)
            make.width.equalTo(109)
            make.height.equalTo(48)
        }
    }

    @objc private func goToStoreCard() {
        websitePublisher.send(storeURL)
    }
}
