import UIKit
import SnapKit

final class ProductNameCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductNameCell"

    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerLarge
        label.numberOfLines = 2
        label.textColor = .cherryBlack
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ProductTitleUIModel) {
        self.productNameLabel.text = model.name
    }

    private func setupViews() {
        contentView.backgroundColor = .cherryWhite
        contentView.addSubview(productNameLabel)

        productNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
