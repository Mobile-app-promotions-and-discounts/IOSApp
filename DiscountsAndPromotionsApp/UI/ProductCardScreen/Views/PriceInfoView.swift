import UIKit
import SnapKit
import Combine

class PriceInfoView: UIView {

    var viewModel: PriceInfoViewViewModelProtocol? {
        didSet {
            print("ViewModel is set")
            bindViewModel()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let toFavoritesButton = PrimaryButton()
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
        print("Configuring with price: \(price), discountPrice: \(discountPrice)")
        viewModel?.updatePrice(price)
        viewModel?.updateDiscountPrice(discountPrice)
    }

    private func bindViewModel() {
        print("Binding ViewModel")
        viewModel?.pricePublisher
            .map { "\($0) ₽" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] price in
                print("Setting worstOriginPrice text to: \(price)")
                self?.worstOriginPrice.text = price}
            .store(in: &cancellables)

        viewModel?.discountPricePublisher
            .map { "от \($0) ₽"}
            .receive(on: DispatchQueue.main)
            .sink { [weak self] discountPrice in
                    print("Setting bestDiscountPrice text to: \(discountPrice)")
                    self?.bestDiscountPrice.text = discountPrice
                }
            .store(in: &cancellables)

        toFavoritesButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel?.addToFavorites.send()
                self?.viewModel?.toggleFavorite()
                self?.updateFavoritesButtonState()
            }
            .store(in: &cancellables)

        updateFavoritesButtonState()
    }

    private func updateFavoritesButtonState() {
        if let isFavorite = viewModel?.isFavorite {
            toFavoritesButton.isUserInteractionEnabled = !isFavorite
            toFavoritesButton.backgroundColor = isFavorite ? .cherryPrimaryDisabled : .cherryMainAccent
        } else {
            toFavoritesButton.isUserInteractionEnabled = true
            toFavoritesButton.backgroundColor = .cherryMainAccent
        }
    }

    private func setupLayout() {
        setupWorstOriginPriceLabel()
        setupBestDiscountPriceLabel()
        setupToFavoritesButton()
        setupConstraints()
    }

    private func setupWorstOriginPriceLabel() {
        worstOriginPrice.textColor = .gray
        worstOriginPrice.font = CherryFonts.textMedium
        worstOriginPrice.attributedText = NSAttributedString(
            string: "300р",
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        addSubview(worstOriginPrice)
    }

    private func setupBestDiscountPriceLabel() {
        bestDiscountPrice.textColor = .black
        bestDiscountPrice.font = CherryFonts.headerExtraLarge
        bestDiscountPrice.text = "от 150р"
        addSubview(bestDiscountPrice)
    }

    private func setupToFavoritesButton() {
        toFavoritesButton.setTitle("В Избранное", for: .normal)
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
