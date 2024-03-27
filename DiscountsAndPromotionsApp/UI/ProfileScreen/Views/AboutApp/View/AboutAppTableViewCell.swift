import SnapKit
import UIKit

final class AboutAppTableViewCell: UITableViewCell {

    // MARK: - Public properties
    static let identifier = "AboutAppTableViewCell"

    // MARK: - Layout elements
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.headerMedium
        label.textAlignment = .left
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: .buttonDisclosure)
        imageView.tintColor = .cherryGrayBlueButton
        return imageView
    }()

    // MARK: - Lifecicle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configure(name: String) {
        self.nameLabel.text = name
    }

    // MARK: - Layout Setting
    private func setupViewAndConstraints() {
        self.backgroundColor = .cherryLightBlue
        self.layer.cornerRadius = Const.viewCornerRadius
        self.selectionStyle = .none

        [nameLabel,
         arrowImageView].forEach { self.addSubview($0) }

        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
                .inset(Const.insetH)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
                .inset(Const.insetH)
            $0.centerY.equalToSuperview()
        }

    }

    private enum Const {
        static let insetH: CGFloat = 12
        static let viewCornerRadius: CGFloat = 10
    }

}
