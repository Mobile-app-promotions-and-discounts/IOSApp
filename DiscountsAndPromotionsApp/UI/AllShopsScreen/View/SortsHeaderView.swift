import UIKit
import SnapKit
import Combine

final class SortsHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SortsHeaderView"

    var cancellable: AnyCancellable?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cherryBlack
        label.font = CherryFonts.headerLarge
        return label
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.icSort, for: .normal)
        button.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.icFilterOff, for: .normal)
        button.setImage(UIImage.icFilterOn, for: .highlighted)
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.axis = .horizontal
        [sortButton, filterButton].forEach { stackView.addArrangedSubview($0) }
        return stackView
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
    private func sortButtonPressed() {
        print("Нажал кнопку Сортировка")
    }

    @objc
    private func filterButtonPressed() {
        print("Нажал кнопку Фильтр")
    }

    private func setupViews() {
        [titleLabel, buttonsStackView].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview()
            make.centerY.equalTo(buttonsStackView.snp.centerY)
            make.trailing.equalTo(buttonsStackView.snp.leading)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
    }
}
