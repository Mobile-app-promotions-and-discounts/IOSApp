import UIKit

final class StarsRatingRegularView: UIView {
    var rating: Int = 0 {
        didSet {
            configureForRating()
        }
    }

    private lazy var starStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 2
        return stack
    }()

    init() {
        super.init(frame: CGRect())
        setupStars()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStars() {
        addSubview(starStack)
        starStack.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }

        for star in 1...5 {
            let starView = StarView(id: star)
            starView.snp.makeConstraints { make in
                make.height.width.equalTo(16)
            }
            starStack.addArrangedSubview(starView)
        }
    }

    private func configureForRating() {
        var rating = self.rating
        if self.rating < 1 {
            rating = 0
        } else if self.rating > 5 {
            rating = 5
        }

        starStack.arrangedSubviews.forEach { star in
            if let star = star as? StarView {
                star.isActive = (star.id < rating)
            }
        }
    }
}
