import UIKit
import SnapKit

class ProductTitleView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerLarge
        label.textColor = .black
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.textMedium
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(weightLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview()

        }
    }

    func configure(with title: String, weight: String) {
        titleLabel.text = title
        weightLabel.text = weight
    }
}
