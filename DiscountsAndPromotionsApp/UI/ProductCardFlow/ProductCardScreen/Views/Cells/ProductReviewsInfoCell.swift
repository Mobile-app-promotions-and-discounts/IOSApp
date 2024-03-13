import UIKit
import SnapKit
import Combine

final class ProductReviewsInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductReviewsInfoCell"

    var cancellable: AnyCancellable?

    private (set) var openReviewsButtonTappedPublisher = PassthroughSubject<Void, Never>()

    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .cherryLightBlueCard
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return view
    }()

    private lazy var starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        return label
    }()

    private let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var openReviewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.icForward2, for: .normal)
        button.addTarget(self, action: #selector(openReviewsButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func openReviewsButtonTapped() {
        openReviewsButtonTappedPublisher.send()
    }

    func configure(with model: ProductReviewsInfoUIModel) {
        configureStackView(with: model.rating)
        self.ratingLabel.text = String(model.rating)
        self.reviewsCountLabel.text = String.getWordForm(model.reviewsCount)
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryWhite
        contentView.addSubview(bgView)
        [starsStackView, ratingLabel, openReviewsButton, reviewsCountLabel].forEach { bgView.addSubview($0) }

        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        starsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(bgView.snp.leading).inset(12)
        }

        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starsStackView.snp.trailing).offset(8)
        }

        openReviewsButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(bgView.snp.trailing).inset(12)
        }

        reviewsCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(openReviewsButton.snp.leading).offset(-8)
        }
    }

    private func configureStackView(with rating: Double) {
        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let fullStars = Int(rating)

        for index in 0..<5 {
            let star = UIImageView()
            star.contentMode = .scaleAspectFit

            if index < fullStars {
                star.image = UIImage.icStarFill
            } else {
                star.image = UIImage.icStar
            }
            starsStackView.addArrangedSubview(star)
        }
    }
}
