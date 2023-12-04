import UIKit
import SnapKit

final class PromotionCell: UICollectionViewCell {
    static let reuseIdentifier = "PromotionCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cherryGrayBlue
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var nameAndDescriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()

    func configure(with product: PromotionUIModel) {
        self.nameLabel.text = product.name
        self.descriptionLabel.text = product.description
    }

    private func setupViews() {
        contentView.backgroundColor = UIColor.cherryWhite
        contentView.layer.cornerRadius = 20

        [productImageView, nameAndDescriptionStackView].forEach { contentView.addSubview($0) }

        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(148)
        }

        nameAndDescriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).inset(-8)
            make.leading.trailing.equalTo(productImageView)
        }
    }
}
