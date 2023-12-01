import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderView"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CherryFonts.headerLarge
        return label
    }()

    private lazy var allButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("All", tableName: "MainFlow", comment: ""), for: .normal)
        button.titleLabel?.font = CherryFonts.textMedium
        button.setTitleColor(.cherryBlue, for: .normal)
        button.addTarget(self, action: #selector(allButtonPressed), for: .touchUpInside)
        return button
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

    @objc
    private func allButtonPressed() {
        print("Нажал кнопку Все")
    }

    private func setupViews() {
        [titleLabel, allButton].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
            make.centerY.equalTo(allButton.snp.centerY)
            make.trailing.equalTo(allButton.snp.leading)
        }

        allButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
        }
    }
}
