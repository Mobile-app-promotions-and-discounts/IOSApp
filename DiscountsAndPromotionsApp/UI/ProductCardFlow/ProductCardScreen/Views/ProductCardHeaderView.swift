import UIKit
import SnapKit

final class ProductCardHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ProductCardHeaderView"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerLarge
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        self.titleLabel.text = title
    }

    private func setupViews() {
        [titleLabel].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview()
        }
    }
}
