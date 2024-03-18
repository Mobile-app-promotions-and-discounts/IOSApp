import Kingfisher
import UIKit

final class MyReviewTableViewCell: UITableViewCell {

    // MARK: - Public properties
    static let identifier = "MyReviewTableViewCell"

    // MARK: - Layout elements
    private lazy var reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Const.cornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var rating = StarsRatingRegularView()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.headerMedium
        label.textColor = .cherryBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = CherryFonts.textSmall
        label.textColor = .cherryBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
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
    func configure(myReviewModel: MyReviewUIModel) {
        rating.rating = myReviewModel.rating
        nameLabel.text = myReviewModel.name
        commentLabel.text = myReviewModel.comment
        if let urlString = myReviewModel.imageURLString,
           let url = URL(string: urlString) {
            reviewImageView.kf.setImage(with: url, placeholder: UIImage(named: "productImagePlaceholder"))
        } else {
            reviewImageView.image = .productImagePlaceholder
        }
    }

    // MARK: - Layout Setting
    private func setupViewAndConstraints() {
        self.backgroundColor = .cherryLightBlue
        self.layer.cornerRadius = Const.cornerRadius
        self.selectionStyle = .none

        [reviewImageView,
         rating,
         nameLabel,
         commentLabel].forEach { self.addSubview($0) }

        reviewImageView.snp.makeConstraints {
            $0.width.equalTo(Const.ImageView.width)
            $0.top.leading.bottom.equalToSuperview()
                .inset(Const.inset)
        }

        rating.snp.makeConstraints {
            $0.top.equalToSuperview()
                .inset(Const.inset)
            $0.leading.equalTo(reviewImageView.snp.trailing)
                .offset(Const.inset)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
                .offset(Const.nameTopOffset)
            $0.leading.equalTo(reviewImageView.snp.trailing)
                .offset(Const.inset)
            $0.trailing.equalToSuperview()
                .inset(Const.inset)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
                .offset(Const.contentSpacing)
            $0.leading.equalTo(reviewImageView.snp.trailing)
                .offset(Const.inset)
            $0.trailing.equalToSuperview()
                .inset(Const.inset)
        }
    }

    private enum Const {
        enum ImageView {
            static let width: CGFloat = 77
        }
        static let nameTopOffset: CGFloat = 28
        static let contentSpacing: CGFloat = 4
        static let inset: CGFloat = 8
        static let cornerRadius: CGFloat = 10
    }

}
