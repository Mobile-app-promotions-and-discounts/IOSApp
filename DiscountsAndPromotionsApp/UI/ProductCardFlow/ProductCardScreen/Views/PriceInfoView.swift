import UIKit
import SnapKit
import Combine

class PriceInfoView: UIView {
    var viewModel: PriceInfoViewViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private lazy var toFavoritesButton: UIButton = {
        let button = PrimaryButton(type: .custom)
        button.setTitle("В избранное", for: .normal)
        button.setTitle("Убрать из избранного", for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    private let worstOriginPrice = UILabel()
    private let bestDiscountPrice = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with price: Int, discountPrice: Int) {
        viewModel?.updatePrice(price)
        viewModel?.updateDiscountPrice(discountPrice)
    }

    func bindViewModel() {
        viewModel?.favoritesUpdate
            .sink { [weak self] _ in
                self?.updateFavoritesButtonState()
            }
            .store(in: &cancellables)

        viewModel?.pricePublisher
            .map { "\($0) ₽" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                self?.worstOriginPrice.text = price}
            .store(in: &cancellables)

        viewModel?.discountPricePublisher
            .map { "от \($0) ₽"}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] discountPrice in
                    self?.bestDiscountPrice.text = discountPrice
                }
            .store(in: &cancellables)

        toFavoritesButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel?.addToFavorites.send()
                self?.viewModel?.toggleFavorite()
                self?.toFavoritesButton.startLoadingAnimation()
            }
            .store(in: &cancellables)

        updateFavoritesButtonState()
    }

    private func updateFavoritesButtonState() {
        toFavoritesButton.stopLoadingAnimation()
        if let isFavorite = viewModel?.isFavorite {
            toFavoritesButton.isSelected = isFavorite
        }
    }

    private func setupLayout() {
        setupWorstOriginPriceLabel()
        setupBestDiscountPriceLabel()
        setupToFavoritesButton()
        setupConstraints()
    }

    private func setupWorstOriginPriceLabel() {
        worstOriginPrice.textColor = .cherryBlack
        worstOriginPrice.font = CherryFonts.textMedium
        worstOriginPrice.attributedText = NSAttributedString(
            string: "...",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        addSubview(worstOriginPrice)
    }

    private func setupBestDiscountPriceLabel() {
        bestDiscountPrice.textColor = .cherryBlack
        bestDiscountPrice.font = CherryFonts.headerExtraLarge
        bestDiscountPrice.text = "от ..."
        addSubview(bestDiscountPrice)
    }

    private func setupToFavoritesButton() {
        toFavoritesButton.backgroundColor = .lightGray
        toFavoritesButton.layer.cornerRadius = CornerRadius.regular.cgFloat()
        toFavoritesButton.titleLabel?.font = CherryFonts.headerMedium
        toFavoritesButton.tintColor = .cherryBlack
        addSubview(toFavoritesButton)
    }

    private func setupConstraints() {
        worstOriginPrice.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(16)
        }

        bestDiscountPrice.snp.makeConstraints { make in
            make.top.equalTo(worstOriginPrice.snp.bottom).offset(4)
            make.leading.equalTo(worstOriginPrice.snp.leading)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(28)
            make.trailing.lessThanOrEqualTo(toFavoritesButton.snp.leading).offset(-16)
        }

        toFavoritesButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-24)
            make.width.equalTo(165)
            make.height.equalTo(51)
        }
    }
}
