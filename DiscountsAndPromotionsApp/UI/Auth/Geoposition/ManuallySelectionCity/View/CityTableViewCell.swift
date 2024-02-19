import SnapKit
import UIKit

final class CityTableViewCell: UITableViewCell {

    static let cellIdentifier = "CityTableViewCell"

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.textSmall
        label.textColor = .cherryBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cityLabel, countryLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Const.spacing
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCity(_ cityModel: CityUIModel) {
        cityLabel.text = cityModel.name
        countryLabel.text = cityModel.country
    }

    private func setupViewAndConstraints() {
        self.backgroundColor = .cherryWhite

        self.addSubview(labelStackView)

        labelStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
                .inset(Const.verticalInset)
            $0.leading.trailing.equalToSuperview()
                .inset(Const.horizontalInset)
        }
    }

    private enum Const {
        static let spacing: CGFloat = 2
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 12
    }

}
