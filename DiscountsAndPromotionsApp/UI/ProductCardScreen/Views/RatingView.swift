import UIKit
import Combine
import SnapKit

class RatingView: UIView {
    var viewModel: RatingViewViewModelProtocol?
    private var cancellables = Set<AnyCancellable>()
    private let starsStackView =  UIStackView()
    private let ratingLabel = UILabel()
    private let numberOfReviewsLabel = UILabel()

    private lazy var reviewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .cherryLightBlue
        button.isUserInteractionEnabled = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureStars()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with rating: Double, numberOfReviews: Int) {
        for (index, star) in starsStackView.arrangedSubviews.enumerated() {
            star.isHidden = index >= Int(rating)
        }
        ratingLabel.text = "\(rating)"
        numberOfReviewsLabel.text = "\(numberOfReviews) отзывов"
    }

    private func setupLayout() {
        backgroundColor = .cherryLightBlue
        layer.cornerRadius = CornerRadius.regular.cgFloat()
        starsStackView.axis = .horizontal
        starsStackView.distribution = .fillEqually
        ratingLabel.font = CherryFonts.textMedium
        numberOfReviewsLabel.font = CherryFonts.textMedium
        numberOfReviewsLabel.textColor = .cherryBlack
        reviewsButton.tintColor = .cherryGray
        addSubview(starsStackView)
        addSubview(ratingLabel)
        addSubview(numberOfReviewsLabel)
        addSubview(reviewsButton)

//        starsStackView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.leading.equalToSuperview().offset(12)
//            make.height.equalTo(16)
//        }

        starsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(16)
        }

        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starsStackView)
            make.leading.equalTo(starsStackView.snp.trailing).offset(8)
        }

        numberOfReviewsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
//            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalTo(reviewsButton.snp.leading).offset(-8)
            make.height.equalTo(19)
        }

        reviewsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
    }

    private func configureStars() {
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage(named: "ic_starFill"))
            star.contentMode = .scaleAspectFit
            star.isHidden = true
            starsStackView.addArrangedSubview(star)
        }
    }

    private func setupBindings() {
        reviewsButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel?.reviewsButtonTapped.send()
            }
            .store(in: &cancellables)
    }
}
