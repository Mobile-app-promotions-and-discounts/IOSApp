import UIKit
import SnapKit

class OfferTableViewCell: UITableViewCell {

    private let backgroundViewBoard = UIView()
    private let logoImageView = UIImageView()
    private let storeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
//    private let discountView = UIView()
    private let discountLabel = UILabel()
    private let goToStoreButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackgroundView()
        addSubviews()
        configureLogoImageView()
//        configureDiscountView()
        configureGoToStoreButton()
        configureLabels()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackgroundView() {
        backgroundViewBoard.backgroundColor = .cherryLightBlue
        backgroundViewBoard.layer.cornerRadius = CornerRadius.regular.cgFloat()
        backgroundViewBoard.clipsToBounds = true
        contentView.addSubview(backgroundViewBoard)
    }

    private func addSubviews() {
        [logoImageView,
         storeNameLabel,
         addressLabel,
         priceLabel,
         originalPriceLabel,
         discountLabel,
//         discountView,
         goToStoreButton].forEach {
            backgroundViewBoard.addSubview($0)
        }
//        discountView.addSubview(discountLabel)
    }

    private func configureLogoImageView() {
        logoImageView.layer.cornerRadius = 14
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .lightGray
    }

    private func configureGoToStoreButton() {
        goToStoreButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        goToStoreButton.tintColor = .cherryGray
        goToStoreButton.addTarget(self, action: #selector(goToStoreCard), for: .touchUpInside)
    }

    private func configureLabels() {
        storeNameLabel.font = CherryFonts.headerMedium
        addressLabel.font = CherryFonts.headerSmall
        priceLabel.font = CherryFonts.textMedium
        originalPriceLabel.font = CherryFonts.textMedium
        originalPriceLabel.textColor = .gray
        originalPriceLabel.attributedText = NSAttributedString(
            string: "180 ₽",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )

        discountLabel.font = CherryFonts.textMedium
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
            make.leading.equalTo(logoImageView.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(goToStoreButton.snp.leading)
            make.height.equalTo(19)
        }

        addressLabel.snp.makeConstraints { make in
            make.bottom.equalTo(storeNameLabel)
            make.leading.equalTo(storeNameLabel.snp.trailing).offset(8)
            make.height.equalTo(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(storeNameLabel)
        }

        discountLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(3)
            make.centerY.equalTo(priceLabel)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(discountLabel.snp.trailing).offset(8)
            make.centerY.equalTo(priceLabel)
        }

        goToStoreButton.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundViewBoard.snp.trailing).offset(-paddingH)
            make.centerY.equalTo(backgroundViewBoard.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
    }

    func configure(with offer: Offer) {
        storeNameLabel.text = offer.store.name
        addressLabel.text = offer.store.location.street
        priceLabel.text = "\(Int(offer.price)) ₽"
//        originalPriceLabel.text = ""
        discountLabel.text = "-\(String(describing: offer.discount?.discountRate ?? 30)) %"
    }

    @objc func goToStoreCard() {
        print("Переход на карточку магазина")
    }
}
