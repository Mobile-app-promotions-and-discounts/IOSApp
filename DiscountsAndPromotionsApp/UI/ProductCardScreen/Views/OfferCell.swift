import UIKit
import SnapKit

class OfferTableViewCell: UITableViewCell {
    private let backgroundViewBoard = UIView()
    private let logoImageView = UIImageView()
    private let storeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let originalPriceLabel = UILabel()
    private let discountLabel = UILabel()
    private let goToStoreButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackgroundView()
        addSubviews()
        configureLogoImageView()
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
         goToStoreButton].forEach {
            backgroundViewBoard.addSubview($0)
        }
    }

    private func configureLogoImageView() {
        logoImageView.layer.cornerRadius = 14
        logoImageView.clipsToBounds = true
        logoImageView.backgroundColor = .lightGray
    }

    private func configureGoToStoreButton() {
        goToStoreButton.setTitle("В магазин", for: .normal)
        goToStoreButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        goToStoreButton.backgroundColor = .white
        goToStoreButton.setTitleColor(.black, for: .normal)
        goToStoreButton.layer.cornerRadius = 10
        goToStoreButton.addTarget(self, action: #selector(goToStoreCard), for: .touchUpInside)
    }

    private func configureLabels() {
        storeNameLabel.font = .boldSystemFont(ofSize: 14)
        addressLabel.font = .systemFont(ofSize: 12)
        priceLabel.font = .boldSystemFont(ofSize: 16)
        originalPriceLabel.font = .systemFont(ofSize: 14)
        originalPriceLabel.textColor = .gray
        originalPriceLabel.attributedText = NSAttributedString(
            string: "180р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        discountLabel.font = .systemFont(ofSize: 14)
        discountLabel.textColor = .red
    }

    private func setupConstraints() {
        let paddingH: CGFloat = 12
        let paddingV: CGFloat = 8

        backgroundViewBoard.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
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
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(storeNameLabel)
            make.trailing.equalTo(storeNameLabel)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(2)
            make.leading.equalTo(storeNameLabel)
            make.bottom.equalTo(backgroundViewBoard).offset(-6)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(4)
            make.bottom.equalTo(priceLabel)
        }

        discountLabel.snp.makeConstraints { make in
            make.leading.equalTo(originalPriceLabel.snp.trailing).offset(4)
            make.bottom.equalTo(priceLabel)
        }

        goToStoreButton.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundViewBoard.snp.trailing).offset(-paddingH)
            make.centerY.equalTo(backgroundViewBoard.snp.centerY)
            make.width.equalTo(84)
            make.height.equalTo(30)
        }
    }

    func configure(with offer: Offer) {
        storeNameLabel.text = offer.store.name
        addressLabel.text = offer.store.location.street
        priceLabel.text = "\(offer.price)"
        discountLabel.text = "\(String(describing: offer.discount?.discountRate))"
    }

    @objc func goToStoreCard() {
        print("Переход на карточку магазина")
    }
}
