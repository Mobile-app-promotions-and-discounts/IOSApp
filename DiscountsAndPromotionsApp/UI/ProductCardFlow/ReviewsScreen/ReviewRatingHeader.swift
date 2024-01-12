import UIKit

final class ReviewRatingHeader: UITableViewHeaderFooterView {
    static let reuseIdentifier = "review header"
    private let insets = UIEdgeInsets(top: 8,
                                      left: 12,
                                      bottom: 8,
                                      right: 12)

    private lazy var starView = {
        UIImageView(image: .icStarBig)
    }()
    private lazy var ratingLabel = {
        let label = UILabel()
        label.textColor = UIColor.cherryBlack
        label.font = CherryFonts.headerExtraLarge
        return label
    }()
    private lazy var reviewCountLabel = {
        let label = UILabel()
        label.textColor = UIColor.cherryBlack
        label.font = CherryFonts.textMedium
        return label
    }()

    func configureFor(rating: Double, reviewCount: Int) {
        setupUI()

        ratingLabel.text = rating.customFormatted()
        reviewCountLabel.text = "Всего отзывов: \(reviewCount)"
    }

    private func setupUI() {
        [starView, ratingLabel, reviewCountLabel].forEach {
            addSubview($0)
        }

        starView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(insets.left)
        }

        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starView.snp.trailing).offset(4)
        }

        reviewCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-insets.right)
        }
    }
}
