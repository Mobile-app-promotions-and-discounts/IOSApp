import UIKit

final class ReviewCell: UITableViewCell {
    private let insets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    private var isSetUp = false
    static let reuseIdentifier = "review cell"

    private lazy var reviewBackground = {
        let background = UIView()
        background.backgroundColor = UIColor.cherryLightBlue
        background.layer.cornerRadius = CornerRadius.regular.cgFloat()
        return background
    }()
    private lazy var starsView = StarsRatingRegularView()
    private lazy var customerLabel = {
        let label = UILabel()
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        label.text = "Аноним"
        label.numberOfLines = 1
        return label
    }()
    private lazy var reviewText = {
        let reviewLabel = UILabel()
        reviewLabel.text = "..."
        reviewLabel.font = CherryFonts.textSmall
        reviewLabel.adjustsFontForContentSizeCategory = false
        reviewLabel.textColor = .cherryBlack
        reviewLabel.numberOfLines = 0
        return reviewLabel
    }()

    override func prepareForReuse() {
        starsView.rating = 0
    }

    func configure(for review: ProductReviewModel) {
        if !isSetUp { setupUI() }
        starsView.rating = review.score
        reviewText.text = review.text
        customerLabel.text = review.user ?? "Аноним"
    }

    private func setupUI() {
        isSetUp = true

        backgroundColor = .cherryWhite
        selectionStyle = .none

        addSubview(reviewBackground)
        [starsView, customerLabel, reviewText].forEach {
            reviewBackground.addSubview($0)
        }

        reviewBackground.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(insets)
        }

        starsView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(8)
        }

        customerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalTo(starsView)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(19)
        }

        reviewText.snp.makeConstraints { make in
            make.top.equalTo(customerLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.leading.trailing.equalTo(customerLabel)
        }
    }
}
