import UIKit
import SnapKit

final class ProductReviewsInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductReviewsInfoCell"
    
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
    
    private let reviewsCountLabel = UILabel()
    
    private lazy var openReviewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.icForward2, for: .normal)
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func configure(with model: ProductTitleUIModel) {
    //        self.productNameLabel.text = model.name
    //    }
    
    private func setupViews() {
        configureStackView()
        contentView.backgroundColor = .cherryLightBlueCard
        contentView.addSubview(productNameLabel)
        
        productNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureStackView() {
        for _ in 0..<5 {
            let star = UIImageView(image: UIImage.icStarFill)
            star.contentMode = .scaleAspectFit
            starsStackView.addArrangedSubview(star)
        }
    }
}
