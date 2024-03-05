import UIKit
import SnapKit
import Combine

final class ProductCardFooterView: UIView {
    private let worstPrice: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.textMedium
        label.text = "300 ₽"
        return label
    }()

    private let bestPrice: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerExtraLarge
        label.text = "от 150 ₽"
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(worstPrice)
        stackView.addArrangedSubview(bestPrice)
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var addToFavoritesButton: UIButton = {
        let button = PrimaryButton(type: .custom)
        button.setTitle(NSLocalizedString("AddToFavorites", tableName: "FavoritesFlow", comment: ""), for: .normal)
        button.setTitle(NSLocalizedString("RemoveFromFavorites", tableName: "FavoritesFlow", comment: ""), for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(addToFavoritesTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    func bindViewModel() {
//        viewModel?.pricePublisher
//            .map { "\($0) ₽" }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] price in
//                self?.worstOriginPrice.text = price}
//            .store(in: &cancellables)
//        
//        viewModel?.discountPricePublisher
//            .map { "от \($0) ₽"}
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] discountPrice in
//                self?.bestDiscountPrice.text = discountPrice
//            }
//            .store(in: &cancellables)
//        
//        toFavoritesButton.publisher(for: .touchUpInside)
//            .sink { [weak self] _ in
//                self?.viewModel?.addToFavorites.send()
//                self?.viewModel?.toggleFavorite()
//                self?.updateFavoritesButtonState()
//            }
//            .store(in: &cancellables)
//        
//        updateFavoritesButtonState()
//    }

//    private func updateFavoritesButtonState() {
//        if let isFavorite = viewModel?.isFavorite {
//            toFavoritesButton.isSelected = isFavorite
//        }
//    }

    @objc
    private func addToFavoritesTapped() {
        addToFavoritesButton.isSelected.toggle()
        print("addToFavoritesTapped")
    }

    private func setupViews() {
        layer.cornerRadius = CornerRadius.regular.cgFloat()
        backgroundColor = .cherryWhite

        [buttonStackView, addToFavoritesButton].forEach { addSubview($0) }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(addToFavoritesButton.snp.leading)
            make.height.equalTo(51)
        }

        addToFavoritesButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(170)
            make.height.equalTo(51)
        }
    }
}
