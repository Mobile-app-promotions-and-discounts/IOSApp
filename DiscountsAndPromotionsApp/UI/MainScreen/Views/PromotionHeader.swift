import UIKit
import SnapKit

final class PromotionHeader: UICollectionReusableView {
    static let reuseIdentifier = "PromotionHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview().offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
