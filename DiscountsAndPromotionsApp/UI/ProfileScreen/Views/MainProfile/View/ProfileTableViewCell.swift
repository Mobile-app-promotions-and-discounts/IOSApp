import SnapKit
import UIKit

final class ProfileTableViewCell: UITableViewCell {

    // MARK: - Public properties
    static let identifier = "ProfileTableViewCell"

    var propertyModel: ProfilePropertyUIModel? {
        didSet {
            nameLabel.text = propertyModel?.name
            logoImageView.image = propertyModel?.image
            if (propertyModel?.comment) != nil {
                commentLabel.text = propertyModel?.comment
                commentLabel.isHidden = false
            }
        }
    }

    // MARK: - Layout elements
    private lazy var logoImageView = UIImageView()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.headerMedium
        label.textAlignment = .left
        label.textColor = .cherryBlack
        return label
    }()

    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .cherryBlack
        label.font = CherryFonts.textSmall
        label.isHidden = true
        return label
    }()

    private lazy var labelVStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, commentLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    private lazy var arrowImageView = UIImageView(image: .buttonDisclosure)

    // MARK: - Lifecicle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configure(propertyModel: ProfilePropertyUIModel) {
        self.propertyModel = propertyModel
    }

    func setComment(_ comment: String) {
        commentLabel.text = comment
        commentLabel.isHidden = false
    }

    // MARK: - Layout Setting
    private func setupViewAndConstraints() {
        self.backgroundColor = .cherryWhite
        self.selectionStyle = .none

        [logoImageView,
         labelVStack,
         arrowImageView].forEach { self.addSubview($0) }

        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
                .offset(Const.LogoImage.leadingOffset)
            $0.width.height.equalTo(Const.LogoImage.widthHeight)
            $0.top.bottom.equalToSuperview()
                .inset(Const.LogoImage.insetV)
        }

        labelVStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(logoImageView.snp.trailing)
                .offset(Const.StackV.leadingOffset)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
                .inset(Const.ArrowImage.trailingInset)
            $0.width.height.equalTo(Const.ArrowImage.widthHeight)
        }

    }

    private enum Const {
        enum LogoImage {
            static let widthHeight: CGFloat = 24
            static let leadingOffset: CGFloat = 12
            static let insetV: CGFloat = 14
        }
        enum StackV {
            static let leadingOffset: CGFloat = 4
            static let spacing: CGFloat = 0
        }
        enum ArrowImage {
            static let trailingInset: CGFloat = 12
            static let widthHeight: CGFloat = 24
        }
    }

}
